![aws-iam-policies](https://cdn.worldvectorlogo.com/logos/aws-iam.svg)

# Collection of useful AWS IAM Resources & Policies

## Links

- [IAM Policy Simulator](https://policysim.aws.amazon.com/home/index.jsp)
- [Policy Generator](https://awspolicygen.s3.amazonaws.com/policygen.html)
- [AWS Identity and Access Management](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
- [Variables for Policies](https://docs.aws.amazon.com/de_de/IAM/latest/UserGuide/reference_policies_variables.html)
- [MFA API Protection](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_configure-api-require.html)
- [MFA S3 Access](https://aws.amazon.com/de/preumiumsupport/knowledge-center/enforce-mfa-other-account-access-bucket/)
- [S3 Bucket Policies](https://docs.aws.amazon.com/AmazonS3/latest/dev/example-bucket-policies.html)
- [Create Policy Alerts](https://docs.oracle.com/en/cloud/paas/casb-cloud/palug/creating-policy-alerts-aws.html#GUID-00652FEE-A065-4D7B-94A9-9FDAC0E90C1E)
- [IAM Slack Notification](https://github.com/Signiant/aws-iam-slack-notifer)

## Policies

#### Allow User to change his Settings

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword",
                "iam:DeleteSSHPublicKey",
                "iam:GetSSHPublicKey",
                "iam:ListSSHPublicKeys",
                "iam:UpdateSSHPublicKey",
                "iam:UploadSSHPublicKey",
                "iam:CreateServiceSpecificCredential",
                "iam:ListServiceSpecificCredentials",
                "iam:UpdateServiceSpecificCredential",
                "iam:DeleteServiceSpecificCredential",
                "iam:ResetServiceSpecificCredential"
            ],
            "Resource": "arn:aws:iam::*:user/${aws:username}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetAccountPasswordPolicy"
            ],
            "Resource": "*"
        }
    ]
}
```


### Protect our Organization in Billing

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ProtectOrganization",
            "Effect": "Deny",
            "Action": [
                "organizations:LeaveOrganization",
                "organizations:DeleteOrganization"
            ],
            "Resource": "arn:aws:organizations::01234567890:organization/o-o-xxxxxxx"
        }
    ]
}
```

### S3 Up

```
```

### 

```
```