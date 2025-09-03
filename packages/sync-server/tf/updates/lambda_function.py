import json
import boto3
import requests
from datetime import datetime

def lambda_handler(event, context):
    ecs = boto3.client('ecs')
    
    # Get current task definition
    response = ecs.describe_services(
        cluster='actual-cluster',
        services=['actual-service']
    )
    
    current_task_def = response['services'][0]['taskDefinition']
    
    # Get current image digest from task definition
    task_def_response = ecs.describe_task_definition(
        taskDefinition=current_task_def
    )
    
    current_image = task_def_response['taskDefinition']['containerDefinitions'][0]['image']
    
    # Check Docker Hub for latest digest
    hub_response = requests.get(
        'https://hub.docker.com/v2/repositories/actualbudget/actual-server/tags/latest'
    )
    
    if hub_response.status_code == 200:
        latest_digest = hub_response.json()['digest']
        
        # Get current running image digest
        running_tasks = ecs.list_tasks(
            cluster='actual-cluster',
            serviceName='actual-service'
        )
        
        if running_tasks['taskArns']:
            task_details = ecs.describe_tasks(
                cluster='actual-cluster',
                tasks=running_tasks['taskArns']
            )
            
            running_digest = task_details['tasks'][0]['containers'][0]['imageDigest']
            
            # Compare digests
            if latest_digest != running_digest:
                print(f"New image available! Triggering deployment...")
                
                # Force new deployment
                ecs.update_service(
                    cluster='actual-cluster',
                    service='actual-service',
                    forceNewDeployment=True
                )
                
                return {
                    'statusCode': 200,
                    'body': json.dumps('Deployment triggered - new image detected')
                }
            else:
                return {
                    'statusCode': 200,
                    'body': json.dumps('No update needed - image is current')
                }
    
    return {
        'statusCode': 500,
        'body': json.dumps('Error checking for updates')
    }
