import from jivas.agent.core.agent { Agent }
import from jivas.agent.action.action { Action }
import from jivas.agent.action.actions { Actions }
import from fastapi { UploadFile }
import from jivas.agent.modules.agentlib.utils { Utils }
import from jac_cloud.plugin.jaseci { JacPlugin as Jac }
import from jivas.agent.action.agent_graph_walker { agent_graph_walker }

walker transcribe_audio(agent_graph_walker) {

    has file: UploadFile;

    obj __specs__ {
        static has private: bool = False;
        static has path: str = Utils.action_walker_path(__module__) + "/{agent_id}";
    }

    can on_agent with Agent entry {
        visit [-->](`?Actions);
    }

    can on_actions with Actions entry {
        visit [-->](`?Action)(?enabled == True)(?label == 'DeepgramSTTAction');
    }

    can on_action with Action entry {

        if not self.file {
            Jac.get_context().status = 400;
            report "No audio file provided";
            disengage;
        }

        if 'audio' not in self.file.type or self.file.type != "application/octet-stream" {
            Jac.get_context().status = 400;
            report "Invalid file type, must be audio";
            disengage;
        }

        result = here.invoke_file(
            audio_content=self.file.content,
            audio_type=self.file.type
        );

        if not isinstance(result, dict) or 'duration' not in result or 'transcript' not in result {
            Jac.get_context().status = 500;
            report "Invalid STT response format";
            disengage;
        }

        report {
            "duration": result["duration"],
            "transcript": result["transcript"]
        };

    }
}
