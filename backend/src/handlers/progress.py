import json
import os
from datetime import datetime, timezone

import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["PROGRESS_TABLE"])


def lambda_handler(event, context):
    try:
        body = json.loads(event.get("body", "{}"))

        user_id = body.get("userId")
        lesson_id = body.get("lessonId")
        completed = body.get("completed", False)

        if not user_id or not lesson_id:
            return {
                "statusCode": 400,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({
                    "message": "userId and lessonId are required"
                })
            }

        item = {
            "userId": user_id,
            "lessonId": lesson_id,
            "completed": completed,
            "timestamp": datetime.now(timezone.utc).isoformat()
        }

        table.put_item(Item=item)

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({
                "message": "Progress saved",
                "item": item
            })
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({
                "message": "Internal server error",
                "error": str(e)
            })
        }