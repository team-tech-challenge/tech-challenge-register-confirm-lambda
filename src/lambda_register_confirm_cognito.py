import json
import boto3
import hmac
import hashlib
import base64
import os
from botocore.exceptions import ClientError

cognito = boto3.client('cognito-idp')

def calculate_secret_hash(client_id, client_secret, username):
    message = username + client_id
    dig = hmac.new(
        str(client_secret).encode('utf-8'),
        msg=str(message).encode('utf-8'),
        digestmod=hashlib.sha256
    ).digest()
    return base64.b64encode(dig).decode()


def lambda_handler(event, context):

    if isinstance(event['body'], str):
        body = json.loads(event['body'])
    else:
        body = event['body']

    username = body['username']
    confirmation_code = body['confirmation_code']

    client_id = os.environ['client_id']
    client_secret = os.environ['client_secret']

    secret_hash = calculate_secret_hash(client_id, client_secret, username)

    try:
        # Confirm the user's sign-up
        response = cognito.confirm_sign_up(
            ClientId=client_id,
            Username=username,
            ConfirmationCode=confirmation_code,
            SecretHash=secret_hash
        )
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'User confirmed and registered successfully'})
        }
    except ClientError as error:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': error.response['Error']['Message']})
        }