import logging;
import from logging { Logger }
import from jivas.agent.core.agent { Agent }
import from jivas.agent.action.action { Action }
import from jivas.agent.action.actions { Actions }
import from jivas.agent.modules.agentlib.utils { Utils }
import from jivas.agent.action.agent_graph_walker { agent_graph_walker }

walker send_messages(agent_graph_walker) {
    # accepts a collection of messages and a callback_url to be queued up for sending
    # the structure of the message items is as follows:

    # TEXT
    # {
    #     "messages": [
    #         {
    #             "to": "session_id",
    #             "message": {
    #                 "message_type": "TEXT",
    #                 "content": "message content"
    #             }
    #         }
    #     ],
    #     "callback_url": "https://example.com/callback"
    # }

    # MEDIA
    # {
    #     "messages": [
    #         {
    #             "to": "session_id",
    #             "message": {
    #                 "message_type": "MEDIA",
    #                 "mime": "image/jpeg",
    #                 "content": "message content",
    #                 "data": {
    #                     "url": "https://example.com/image.jpg",
    #                     "file_name": "image.jpg"
    #                 }
    #             }
    #         }
    #     ],
    #     "callback_url": "https://example.com/callback"
    # }

    # MULTI
    # {
    #     "messages": [
    #         {
    #             "to": "session_id",
    #             "message": {
    #                 "message_type": "MULTI",
    #                 "content": [
    #                     {
    #                         "message_type": "TEXT",
    #                         "content": "message content"
    #                     },
    #                     {
    #                         "message_type": "MEDIA",
    #                         "mime": "image/jpeg",
    #                         "content": "message content",
    #                         "data": {
    #                             "url": "https://example.com/image.jpg",
    #                             "file_name": "image.jpg"
    #                         }
    #                     }
    #                 ]
    #             }
    #         }
    #     ]
    # }
    
    # returns a job id or None if the message is invalid

    class __specs__ {
        static has private: bool = False;
        static has path: str = Utils.action_walker_path(__module__);
    }

    has messages:list = [];
    has callback_url:str = '';
    has response:str = '';

    # set up logger
    static has logger:Logger = logging.getLogger(__name__);

    obj __specs__ {
        # make this walker visible in API
        static has private: bool = False;
    }

    can on_agent with Agent entry {
        visit [-->](`?Actions);
    }

    can on_actions with Actions entry {
        visit [-->](`?Action)(?enabled==True)(?label=='WPPConnectAction');
    }

    can on_action with Action entry {
        self.response = here.add_outbox_job(messages=self.messages, callback_url=self.callback_url);
        if self.reporting {
            report self.response;
        }
    }

}