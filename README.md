# terraform-aws-lambda
This repo contains Terraform modules to manage Lamdbas:

| Directory          | Module Description                                 |
| ------------------ | -------------------------------------------------- |
| lambda_function/   | Lambda Function and IAM, Trigger, and CI resources |
| lambda_layer/      | Lambda Layer and CI resources                      |

These modules are primarily designed to deploy Lambda functions and layers with _placeholder_ code and then use an
external CI/CD process to manage the function and layer code independently of Terraform.

You can optionally provide a GitHub repo containing your function or layer code and the modules will create a simple
CodeBuild job to deploy it.

## Arguments

### Common

| argument                  | Description                                                               | Default      |
| ------------------------- | --------------------------------------------------------------------------| ------------ |
| github_url                | GitHub URL of function or layer code.  Enables CodeBuild.  Assumes buildspec.yml at root of repo.  Requires github_token_ssm_param | "" |
| github_token_ssm_param    | SSM Parameter containing GitHub token with permission to create webhook   | ""           |
| codebuild_credential_arn  | AWS Codebuild source credential for accessing github                      | ""           |

### lambda_function
Many of the module arguments map directly to the [aws_lambda_function](https://www.terraform.io/docs/providers/aws/r/lambda_function.html) resource arguments:
* function_name 
* filename
* description
* runtime
* handler
* timeout
* layers
* memory_size
* environment_variables
* tags
* vpc_config
* reserved_concurrent_executions
* publish

Additional arguments:

| argument                  | Description                                                               | Default      |
| ------------------------- | --------------------------------------------------------------------------| ------------ |
| create_empty_function     | Create an empty lambda function without the actual code if set to true    | True         |
| policies                  | List of statement policies to add to module-manageg Lambda IAM role role. | []           |
| permissions               | list of external resources which can invoke the lambda function           | {}           |

### lambda_layer
Many of the module arguments map directly to the [aws_lambda_layer_version](https://www.terraform.io/docs/providers/aws/r/lambda_layer_version.html) resource arguments:
* layer_name
* filename
* description
* runtime


Additional arguments:

| argument                  | Description                                                               | Default      |
| ------------------------- | --------------------------------------------------------------------------| ------------ |
| create_empty_layer        | Create an empty lambda layer without the actual code if set to true       | True         |
| codebuild_image           | Specify Codebuild's [image](https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html) | "aws/codebuild/standard:1.0" |
| privileged_mode           | Run the docker container with [privilege](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities)               | False         |


# Function Event trigger arguments

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



[]: https://www.terraform.io/docs/providers/aws/r/lambda_function.html