# Actual Budget Auto-Update Lambda

This Lambda function automatically checks for new versions of the `actualbudget/actual-server:latest` Docker image and triggers ECS service deployments when updates are available.

## Manual Monitoring Alternative

You can also manually monitor for updates by watching the official releases at:
https://github.com/actualbudget/actual/releases

## Files

- `lambda_function.py` - Main Lambda function code
- `iam_policy.json` - IAM policy for Lambda execution role

## How it works

1. **Checks current running image digest** from ECS service
2. **Queries Docker Hub API** for latest image digest
3. **Compares digests** to detect updates
4. **Triggers force deployment** if new image is available

## Deployment Options

### Manual Terraform (Future)
```hcl
resource "aws_lambda_function" "image_updater" {
  filename         = "lambda_function.zip"
  function_name    = "actual-image-updater"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
}

resource "aws_cloudwatch_event_rule" "daily_check" {
  name                = "actual-daily-update-check"
  schedule_expression = "cron(0 6 * * ? *)"  # 6 AM UTC daily
}
```

### Manual AWS CLI
```bash
# Create deployment package
zip lambda_function.zip lambda_function.py

# Create function
aws lambda create-function \
  --function-name actual-image-updater \
  --runtime python3.9 \
  --role arn:aws:iam::ACCOUNT:role/lambda-execution-role \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://lambda_function.zip

# Schedule daily execution
aws events put-rule \
  --name actual-daily-update-check \
  --schedule-expression "cron(0 6 * * ? *)"
```

## IAM Requirements

The Lambda function requires the IAM policy in `iam_policy.json` to:
- Read ECS service and task information
- Trigger ECS service deployments
- Write to CloudWatch Logs

## Monitoring

- **CloudWatch Logs**: Function execution logs
- **ECS Events**: Service deployment status
- **Lambda Metrics**: Invocation success/failure rates
