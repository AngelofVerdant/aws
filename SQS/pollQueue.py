import boto3
import time

def poll_sqs_queue(queue_url):
    sqs = boto3.client('sqs')

    while True:
        # Long polling to receive messages (wait for up to 20 seconds for a message)
        response = sqs.receive_message(
            QueueUrl=queue_url,
            WaitTimeSeconds=20
        )

        if 'Messages' in response:
            for message in response['Messages']:
                print(f"Received message: {message['Body']}")
                
                # Delete the message from the queue after processing
                
                sqs.delete_message(
                    QueueUrl=queue_url,
                    ReceiptHandle=message['ReceiptHandle']
                )
        else:
            print("No messages received. Waiting for messages...")
        
        time.sleep(1)  # Optional: Adjust the time interval for polling

# Replace 'YOUR_QUEUE_URL' with the actual SQS queue URL
queue_url = 'YOUR_QUEUE_URL_HERE'

poll_sqs_queue(queue_url)
