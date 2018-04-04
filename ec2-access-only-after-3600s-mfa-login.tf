resource "aws_iam_policy" "main" {
  name        = "ec2MfaOnly"
  path        = "/"
  description = "allow access to ec2 instances only after min 3600s login with mfa"

  policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["ec2:*"],
    "Resource": ["*"],
    "Condition": {"NumericLessThan": {"aws:MultiFactorAuthAge": "3600"}}
    }]
  }
  EOF
}
