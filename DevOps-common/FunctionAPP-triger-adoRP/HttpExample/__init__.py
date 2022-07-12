import logging
from azure.devops.connection import Connection
from msrest.authentication import BasicAuthentication
import urllib3
import json
import base64
import azure.functions as func


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    dbname = req.params.get('dbname')
    subscription_id = req.params.get('subscription')
    rsg_id = req.params.get('rsgroup')

    if not dbname:
        try:
            req_body = req.get_json()
            pass
        except ValueError:
            pass
        else:
        
            dbname = req_body.get('dbname')
            subscription_id = req_body.get('subscription')
            rsg_id = req_body.get('rsgroup')
            
            

    if dbname:
        pat = 'xxxxx'  #
        authorization = str(base64.b64encode(bytes(':'+pat, 'ascii')), 'ascii')
        headers = {
            'Accept': 'application/json',
            'Authorization': 'Basic '+authorization,
            'Content-Type': 'application/json'
        }
        http = urllib3.PoolManager()

        #Release Pipleine Triggering       
    
        url1 = "https://vsrm.dev.azure.com/{organization}/{project}/_apis/release/releases?api-version=6.0" #
         
        print(url1)

        data1 = {
            "definitionId": 790,
            "description": "Creating Sample release",
            "variables": {
                "DBServerName": {
                "value": dbname
                },
                "DBSubscription": {
                    "value": subscription_id
                },
                "DBResourceGroup": {
                    "value": rsg_id
                    
                }
            },
            "artifacts": [],
            "isDraft": 'false',
            "reason": "creating new release for work",
            "manualEnvironments": [],
            
            }
        
        encoded_data1 = json.dumps(data1).encode('utf-8')
        release_data = http.request('POST', url1, headers=headers, body=encoded_data1)
       
        print(release_data.status)

        rel_status = release_data.status
        if rel_status == 200:
            resp = json.loads(release_data.data)

            release_id = resp['id']
            
            
            print("Reelase id:", resp['id'])
            index=0
            for release in resp['environments']:
                    name = release['name']
                    env_id = release['id']
                    print("[" + str(index) + "] " + str(env_id) + "-" + name)
                    index+=1
                    
                    #if name == "Deploy":
                    print("=====triggering deployment pipeline")

                    # Trigger Deployment

                    url2 = "https://vsrm.dev.azure.com/{organization}/{project}/_apis/Release/releases/" + str(release_id) + "/environments/" + str(env_id) + "?api-version=5.1-preview.6" #
                    data2 ={
                    "status": "inProgress",
                    "scheduledDeploymentTime": "",
                    "comment": "testing db"   
                    }

                    
                    encoded_data2 = json.dumps(data2).encode('utf-8')
                    deployment_data = http.request('PATCH', url2, headers=headers, body=encoded_data2)
                    
                    
                    deployment_response = json.loads(deployment_data.data)
                    print(deployment_data.status)
                    print(deployment_response)
        else:
            print("creation of relese failed")

        return func.HttpResponse(f"Hello, {dbname}. subscription {subscription_id}  rgroup {rsg_id} This HTTP triggered function executed successfully.")
    
    else:
        print("Release with DB name was not found")
        return func.HttpResponse("This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.",  status_code=200)

