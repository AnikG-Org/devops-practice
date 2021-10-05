import urllib3
import base64
import json

# REST API auth connection
def api_connection():
    pat = 'xxxxxxxxxxxxii2ujyxgpmmzsrchrvij42wxxxxxxxxxxx'
    authorization = str(base64.b64encode(bytes(':'+pat, 'ascii')), 'ascii')
    headers = {
        'Accept': 'application/json',
        'Authorization': 'Basic '+authorization,
        'Content-Type': 'application/json'
        
    }
    http = urllib3.PoolManager()
    return [http,headers];
    
def delete_agents(orgname,agent_pool_id,agent_name,agent_id):
    connection = api_connection()
    agent_delete_url = "https://dev.azure.com/" + orgname + "/_apis/distributedtask/pools/" + str(agent_pool_id) +  "/agents/" + str(agent_id) + "?api-version=6.0"
    resp2 = connection[0].request('DELETE', agent_delete_url, headers=connection[1])
    #print(resp2.data)
    print("Deleted Offline Agent---" + agent_name)
    #print(resp2.status)

# agents list
def list_agents(orgname,agent_pool_name):
    connection = api_connection()
    url="https://dev.azure.com/" + orgname + "/_apis/distributedtask/pools?poolName=" +  agent_pool_name + "&api-version=6.0"
    #azdo_url= "https://dev.azure.com/" + orgname + "/_apis/distributedtask/pools/" + pool_id + "/agents/" + agent_id + "?api-version=6.0"
    resp = connection[0].request('GET', url, headers=connection[1])
    #print(resp.data)
    data = json.loads(resp.data)
    
    print("Agent Pool Count:", data['count'])
    pool_id = ""
    for agent in data['value']:
            list = agent['name']
            pool_id = agent['id']
           
    print("pool-id", pool_id)
    
    ##get the agents with pool id
    agent_list_url = "https://dev.azure.com/" + orgname + "/_apis/distributedtask/pools/" + str(pool_id) +  "/agents?api-version=6.0"
    resp1 = connection[0].request('GET', agent_list_url, headers=connection[1])
    #print(resp.data)
    data1 = json.loads(resp1.data)
    
    print("Agents Count:", data1['count'])
    #print(data1['value'])
    index=0
    offline_agents = []
    online_agents = []
    for agent_list in data1['value']:
            agent_name = agent_list['name']
            agent_id = agent_list['id']
            agent_status = agent_list['status']
            #print("[" + str(index) + "] " + agent_name + "----agent-id----" + str(agent_id) +  "-----agent-status----" + agent_status)
            index+=1
           
            ###delete
           
            if agent_status == "offline":
                offline_agents.append(agent_status)
                delete_agents("poc-data-lab",pool_id,agent_name,agent_id)
            else:
                online_agents.append(agent_status)
                #print("Total Online agents are------" + str(online_agents.count('online')))
                 
                
    print("Total offline agents are ===",offline_agents.count('offline'))
    print("Total online agents are ===",online_agents.count('online'))            
                
list_agents("poc-data-lab","ADO-K8S-Agents")


    


