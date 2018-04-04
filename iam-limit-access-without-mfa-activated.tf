resource "aws_iam_policy" "policy" {
  name        = "limit-blast-radius-for-user-without-mfa"
  path        = "/"
  description = "limit access for user without mfa"

  policy = <<EOF
    {
        "Sid": "DenyEverythingExceptForBelowUnlessMFA",
        "Effect": "Deny",
        "NotAction": [
            "iam:ListVirtualMFADevices",
            "iam:ListMFADevices",
            "iam:ListUsers",
            "iam:ListAccountAliases",
            "iam:CreateVirtualMFADevice",
            "iam:DeactivateMFADevice",
            "iam:DeleteVirtualMFADevice",
            "iam:EnableMFADevice",
            "iam:ResyncMFADevice",
            "iam:ChangePassword",
            "iam:CreateLoginProfile",
            "iam:DeleteLoginProfile",
            "iam:GetAccountPasswordPolicy",
            "iam:GetAccountSummary",
            "iam:GetLoginProfile",
            "iam:UpdateLoginProfile"
        ],
        "Resource": "*",
        "Condition": {
            "Null": [
                "aws:MultiFactorAuthAge": "true"
            ]
        }
    }
EOF
}
