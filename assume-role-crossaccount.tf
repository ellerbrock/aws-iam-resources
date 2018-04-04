resource "aws_iam_policy" "main" {
  name        = "assume-role-crossaccount"
  path        = "/"
  description = "allow crossfunctional permissions based on sts"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::012345678901:user/maik",
        "AWS": "arn:aws:iam::012345678902:user/ellerbrock"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
  EOF
}
