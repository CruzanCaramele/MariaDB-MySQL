#--------------------------------------------------------------
# Bastion Artifact (AMI)
#--------------------------------------------------------------
resource "aws_vpc" "database_setup" {
	cidr_block           = "10.0.0.0/16"
	enable_dns_support   = true
	enable_dns_hostnames = true
}