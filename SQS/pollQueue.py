import json
import boto3

def lambda_handler(event, context):
    # Replace 'YOUR_QUEUE_URL' with your SQS queue URL
    queue_url = 'YOUR_QUEUE_URL'

    # Create SQS client
    sqs = boto3.client('sqs')

    # Receive message from SQS queue
    response = sqs.receive_message(
        QueueUrl=queue_url,
        MaxNumberOfMessages=100,  # Maximum number of messages to receive
        WaitTimeSeconds=0 # Wait time for messages to arrive (0 to 20 seconds)
    )

    # Check if messages are received
    if 'Messages' in response:
        for message in response['Messages']:
            # Print message body to Lambda logs
            print(f"Received message: {message['Body']}")

            # Delete the message from the queue so it's not processed again
            sqs.delete_message(
                QueueUrl=queue_url,
                ReceiptHandle=message['ReceiptHandle']
            )
    else:
        print("No messages available in the queue")

    return {
        'statusCode': 200,
        'body': json.dumps('Finished processing messages!')
    }
