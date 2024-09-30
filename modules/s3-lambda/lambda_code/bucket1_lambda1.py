import os

def lambda_handler(event, context):
    bucket_name = os.getenv('BUCKET_NAME', 'No bucket name set')
    
    print(f"The bucket name is: {bucket_name}")
    
    return {
        'statusCode': 200,
        'body': f"The bucket name is: {bucket_name}"
    }