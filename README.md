# terraform-aws-lambda
terraform module for provisioning a lambda function 

For most scenarios I would reccomend using the "create_empty_function" argument, rather than using terraform to deploy the function code. Once all infrastructure, functions, and permisisons have been provisioned using terraform, you should use your CI/CD tooling to deploy the function code, typically with and **aws lambda update** command.


# Arguments
Many of the module arguments map directly to the aws_lambda_function resource arguments:
* function_name 
* filename
* description
* runtime
* handler
* timeout
* memory_size
* environment_variables
* tags
* vpc_config
* reserved_concurrent_executions
* publish

Additional arguments are:
* **create_empty_function** - (Required) (bool) - Create an empty lambda function without the actual code if set to true
* **policies** - (Required) (list) - The module automatically creates a base IAM role for each lambda, This is a list of statement policies to add to that role. The contents are converted to json using the jsonencode() function.
* **permissions** - (Optional) (list) - A list of external resources which can invoke the lambda function such as s3 bucket / sns topic. Properties are:
  * statement_id
  * action
  * principal
  * source_arn


# Event trigger arguments

## SNS topic trigger
* **sns_topic_subscription** (Optional) (map) - The SNS topic ARN which trigger the lambda function`

## Cron schedule
* **trigger_schedule** (Optional) (map) - Configures the lambda function to trigger on a schedule. Properties
    * enabled (bool) - true | false
    * schedule_expression (string) - AWS schedule expressions rule: https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html . Examples
        * rate(5 minutes)
        * rate(1 hour)
        * rate(1 day)


## S3 bucket trigger

In addition to the trigger, make sure you 
 * Add sufficient permissions to the lambda role to interact with s3 (E.g s3:GetObject)
 * Add the source resource has permissions to invoke the lambda (see **permissions** argument)

* **bucket_trigger** - (Optional) (map) - Configures the lambda function to trigger on s3 bucket ObjectCreated events. Has two properties:
    * enabled (bool) - true | false
    * bucket (string) - The bucket name only (Not the full bucket arn!)


## SQS trigger

Ensure you add the following permissions to the lambda role
* sqs:ReceiveMessage
* sqs:DeleteMessage
* sqs:GetQueueAttributes

* **source_mappings** - (Optional) (list) - A list of maps to configured the lambda function to trigger on sqs events. Maps to resource aws_lambda_event_source_mapping. Has the following properties
  * enabled (bool) - true | false
  * event_source_arn (string) - arn of the event source
  * batch_size (int) - The largest number of records that Lambda will retrieve from your event source at the time of invocation

