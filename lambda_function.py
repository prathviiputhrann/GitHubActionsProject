import json

def lambda_handler(event, context):
    message = "Helloooooo from the Lambda!"
    print(f"Lambda Output: {message}")  # Logs output in CloudWatch
    return {
        'statusCode': 200,
        'body': json.dumps(message)
    }
