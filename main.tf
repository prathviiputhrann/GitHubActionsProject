# PROVIDER: Configuring AWS Provider
provider "aws" {
  region = "us-east-1"
}

# IAM ROLE: Creates an IAM role for Lambda Execution
resource "aws_iam_role" "lambda_exec_roles" {
  name = "lambda_exec_roles"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# IAM POLICY: Attach AWS Managed Policies for Lambda Permissions
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec_roles.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ZIP FILE: Package Lambda Function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

# LAMBDA FUNCTION: Create AWS Lambda Function
resource "aws_lambda_function" "my_lambda" {
  function_name    = "MyLambdaFunction"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = aws_iam_role.lambda_exec_roles.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.8"
}
