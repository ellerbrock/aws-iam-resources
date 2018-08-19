![aws-iam-policies](https://s3-us-west-1.amazonaws.com/www.jcolemorrison.com/blog/posts/iam-nutshells-3-22-2017/post-head-white.png)

# Collection of useful AWS IAM Resources & Policies [![Build Status](https://travis-ci.org/ellerbrock/aws-iam-resources.svg?branch=master)](https://travis-ci.org/ellerbrock/aws-iam-resources)

## Links

- [IAM Policy Simulator](https://policysim.aws.amazon.com/home/index.jsp)
- [Policy Generator](https://awspolicygen.s3.amazonaws.com/policygen.html)
- [AWS Identity and Access Management](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
- [Policies Variables](https://docs.aws.amazon.com/de_de/IAM/latest/UserGuide/reference_policies_variables.html)
- [MFA API Protection](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_configure-api-require.html)
- [MFA S3 Delete](https://docs.aws.amazon.com/AmazonS3/latest/dev/Versioning.html#MultiFactorAuthenticationDelete)
- [S3 Bucket Policies](https://docs.aws.amazon.com/AmazonS3/latest/dev/example-bucket-policies.html)
- [IAM Slack Notification](https://github.com/Signiant/aws-iam-slack-notifer)
- [Envelope Encryption](https://docs.aws.amazon.com/kms/latest/developerguide/workflow.html)
- [Security Token Service](https://docs.aws.amazon.com/STS/latest/APIReference/Welcome.html)

## Policies

### S3 Bucket Policy to Only Allow Encrypted Object Uploads

```json
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

```json
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

```json
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

```json
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


### Granting an IAM User Permission to Pass an IAM Role to an Instance

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
         "ec2:RunInstances",
         "ec2:AssociateIamInstanceProfile",
         "ec2:ReplaceIamInstanceProfileAssociation"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "*"
    }
  ]
}
```

Source: <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#permission-to-pass-iam-roles>


### Denying Using a STS Rolle Without Valid MFA Authentication

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<ACCOUNT_ID>:<USERNAME>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
```


### IP restriction but allow User to switch Role

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "NotAction": "sts:AssumeRole",
            "Resource": "*",
            "Condition": {
                "NotIpAddress": {
                     "aws:SourceIp": [
                         "123.123.123.123/24"
                     ]
                }
             }
         }
     ]
}
```

Source: <https://aws.amazon.com/premiumsupport/knowledge-center/source-ip-switch-role/>


### Denies Access to AWS Based on the Source IP

```json
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Deny",
        "Action": "*",
        "Resource": "*",
        "Condition": {
            "NotIpAddress": {
                "aws:SourceIp": [
                    "192.0.2.0/24",
                    "203.0.113.0/24"
                ]
            }
        }
    }
}
```

Source: <https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_aws_deny-ip.html>


### S3 Restricting Access to a Specific VPC Endpoint

```json
{
   "Version": "2012-10-17",
   "Id": "Policy1415115909152",
   "Statement": [
     {
       "Sid": "Access-to-specific-VPCE-only",
       "Principal": "*",
       "Action": "s3:*",
       "Effect": "Deny",
       "Resource": ["arn:aws:s3:::examplebucket",
                    "arn:aws:s3:::examplebucket/*"],
       "Condition": {
         "StringNotEquals": {
           "aws:sourceVpce": "vpce-1a2b3c4d"
         }
       }
     }
   ]
}
```

Source: <https://docs.aws.amazon.com/AmazonS3/latest/dev/example-bucket-policies-vpc-endpoint.html>



### Limit KMS Key Usage for defined Services only

*In this example allow KMS usage only for EBS and RDS.*

```json
{
  "Effect": "Allow",
  "Principal": {
    "AWS": "arn:aws:iam::111122223333:user/ExampleUser"
  },
  "Action": [
    "kms:Encrypt",
    "kms:Decrypt",
    "kms:ReEncrypt*",
    "kms:GenerateDataKey*",
    "kms:CreateGrant",
    "kms:ListGrants",
    "kms:DescribeKey"
  ],
  "Resource": "*",
  "Condition": {
    "StringEquals": {
      "kms:ViaService": [
        "ec2.us-west-2.amazonaws.com",
        "rds.us-west-2.amazonaws.com"
      ]
    }
  }
}
```

Source: <https://docs.aws.amazon.com/kms/latest/developerguide/policy-conditions.html#conditions-kms-via-service>

<!--

### 

```json
```

Source: <>

-->