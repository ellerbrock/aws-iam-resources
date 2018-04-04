![aws-iam-policies](https://s3-us-west-1.amazonaws.com/www.jcolemorrison.com/blog/posts/iam-nutshells-3-22-2017/post-head-white.png)

# Collection of useful AWS IAM Resources & Policies

## Links

- [IAM Policy Simulator](https://policysim.aws.amazon.com/home/index.jsp)
- [Policy Generator](https://awspolicygen.s3.amazonaws.com/policygen.html)
- [AWS Identity and Access Management](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
- [Variables for Policies](https://docs.aws.amazon.com/de_de/IAM/latest/UserGuide/reference_policies_variables.html)
- [MFA API Protection](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_configure-api-require.html)
- [MFA S3 Access](https://aws.amazon.com/de/preumiumsupport/knowledge-center/enforce-mfa-other-account-access-bucket/)
- [MFA S3 Delete](https://docs.aws.amazon.com/AmazonS3/latest/dev/Versioning.html#MultiFactorAuthenticationDelete)
- [S3 Bucket Policies](https://docs.aws.amazon.com/AmazonS3/latest/dev/example-bucket-policies.html)
- [Create Policy Alerts](https://docs.oracle.com/en/cloud/paas/casb-cloud/palug/creating-policy-alerts-aws.html#GUID-00652FEE-A065-4D7B-94A9-9FDAC0E90C1E)
- [IAM Slack Notification](https://github.com/Signiant/aws-iam-slack-notifer)
- [Envelope Encryption](https://docs.aws.amazon.com/kms/latest/developerguide/workflow.html)

## Policies

### S3 Bucket Policy to Only Allow Encrypted Object Uploads

```
{
     "Version": "2012-10-17",
     "Id": "PutObjPolicy",
     "Statement": [
           {
                "Sid": "DenyIncorrectEncryptionHeader",
                "Effect": "Deny",
                "Principal": "*",
                "Action": "s3:PutObject",
                "Resource": "arn:aws:s3:::<bucket_name>/*",
                "Condition": {
                        "StringNotEquals": {
                               "s3:x-amz-server-side-encryption": "AES256"
                         }
                }
           },
           {
                "Sid": "DenyUnEncryptedObjectUploads",
                "Effect": "Deny",
                "Principal": "*",
                "Action": "s3:PutObject",
                "Resource": "arn:aws:s3:::<bucket_name>/*",
                "Condition": {
                        "Null": {
                               "s3:x-amz-server-side-encryption": true
                        }
               }
           }
     ]
 }
```

Source: <https://aws.amazon.com/de/blogs/security/how-to-prevent-uploads-of-unencrypted-objects-to-amazon-s3/>


### Granting Access After Recent MFA Authentication (GetSessionToken)

```
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["ec2:*"],
    "Resource": ["*"],
    "Condition": {"NumericLessThan": {"aws:MultiFactorAuthAge": "3600"}}
  }]
}
```

Source: <https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_sample-policies.html#ExampleMFAforIAMUserAge>

### Denying Access to Specific APIs Without Valid MFA Authentication (GetSessionToken)

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAllActionsForEC2",
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    },
    {
      "Sid": "DenyStopAndTerminateWhenMFAIsNotPresent",
      "Effect": "Deny",
      "Action": [
        "ec2:StopInstances",
        "ec2:TerminateInstances"
      ],
      "Resource": "*",
      "Condition": {"BoolIfExists": {"aws:MultiFactorAuthPresent": false}}
    }
  ]
}
```

Source: <https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_sample-policies.html#ExampleMFAforResource>


### Denying Access to Specific APIs Without Recent Valid MFA Authentication (GetSessionToken)

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAllActionsForEC2",
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    },
    {
      "Sid": "DenyStopAndTerminateWhenMFAIsNotPresent",
      "Effect": "Deny",
      "Action": [
        "ec2:StopInstances",
        "ec2:TerminateInstances"
      ],
      "Resource": "*",
      "Condition": {"BoolIfExists": {"aws:MultiFactorAuthPresent": false}}
    },
    {
      "Sid": "DenyStopAndTerminateWhenMFAIsOlderThanOneHour",
      "Effect": "Deny",
      "Action": [
        "ec2:StopInstances",
        "ec2:TerminateInstances"
      ],
      "Resource": "*",
      "Condition": {"NumericGreaterThanIfExists": {"aws:MultiFactorAuthAge": "3600"}}
    }
  ]
}
```

Source: <https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_sample-policies.html#ExampleMFADenyNotRecent>


<!--

### 

```
```

Source: <>

-->