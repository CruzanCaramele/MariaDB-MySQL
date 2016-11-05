#--------------------------------------------------------------
# S3 Bucket Policy
#--------------------------------------------------------------
resource "aws_iam_policy" "s3_bucket_policy" {
  name        = "s3_bucket_policy"
  path        = "/"
  description = "policy to be used by iam role for access to s3 bucket"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1477654877000",
            "Effect": "Allow",
            "Action": [
                "ec2:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "Stmt1477654895000",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

#--------------------------------------------------------------
# Backup Role
#--------------------------------------------------------------
resource "aws_iam_role" "backup_role" {
  name = "backup_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#--------------------------------------------------------------
# IAM Role Policy Attachment
#--------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "backup_policy_attachment" {
  role       = "${aws_iam_role.backup_role.name}"
  policy_arn = "${aws_iam_policy.s3_bucket_policy.arn}"
}

#--------------------------------------------------------------
# IAM Instance Profile
#--------------------------------------------------------------
resource "aws_iam_instance_profile" "instance_profile" {
  name  = "iam_instance_profile"
  roles = ["${aws_iam_role.backup_role.name}"]
}
