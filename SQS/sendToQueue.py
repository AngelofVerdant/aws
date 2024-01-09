import json
import boto3

def lambda_handler(event, context):
    # Replace 'YOUR_QUEUE_URL' with your SQS queue URL
    queue_url = 'https://sqs.us-west-2.amazonaws.com/978003224871/testQueue'

    # Message to be sent to SQS queue
    message_body = 'Boruto is better than Naruto,hehe, did I touch a nerve?'

    # Create SQS client
    sqs = boto3.client('sqs')

    # Send message to SQS queue
    response = sqs.send_message(
        QueueUrl=queue_url,
        MessageBody=message_body
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Message sent to SQS successfully!')
    }
