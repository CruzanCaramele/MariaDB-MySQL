#--------------------------------------------------------------
# S3 Bucket
#--------------------------------------------------------------
resource "aws_s3_bucket" "db-backup-bucket" {
	bucket = "dbBucketBacking"
	acl    = "private"

	tags {
		Name        = "db-backup-bucket"
		Environment = "Prod" 
	}
}