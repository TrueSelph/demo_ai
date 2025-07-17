# Importing the JIVAS graph nodes
import from jivas.agent.core.agents { Agents }
import from jivas.agent.core.agent { Agent }

import from jivas.agent.action.action { Action }
import from jivas.agent.action.actions { Actions }
import from jivas.agent.memory.memory { Memory }


# walkers to execute the each functionality
import from delete_agent { delete_agent }
import from import_memory { import_memory }
import from memory_healthcheck { memory_healthcheck }
import from get_logging { get_logging }


with entry {
    # create the entire graph here first
    agents = root ++> Agents();
    agent = agents[0] ++> Agent();
    memory = agent[0] ++> Memory();
    actions = agent[0] ++> Actions();
    action = actions[0] ++> Action(label='AgentUtilsAction');
    action[0].agent_id = agent[0].id;
}

test delete_agent {
    agents = root ++> Agents();
    agent = agents[0] ++> Agent();
    agent_id = jid(agent[0]);
    agents[0] spawn delete_agent(agent_id=agent_id);
    check len([agents-->]) == 0;
}

test memory_healthcheck {
    response_walker = agent[0] spawn memory_healthcheck();
    check response_walker.response.get('total_frames') == 0;
    check response_walker.response.get('total_interactions') == 0;
}

test get_logging {
    response_walker = agent[0] spawn get_logging();
    check response_walker.response == True;
}



