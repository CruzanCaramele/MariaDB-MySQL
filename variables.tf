#--------------------------------------------------------------
# Access and Secret Keys
#--------------------------------------------------------------
variable "aws_access_key" {
	type        = "string"
	description = "Access Key Account"
	default     = "{{env `AWS_ACCESS_KEY_ID`}}"
}

variable "aws_secret_key" {
	type        = "string"
	description = "Secret Key Account"
	default     = "{{env `AWS_SECRET_ACCESS_KEY`}}"
}

#--------------------------------------------------------------
# Region
#--------------------------------------------------------------
variable "region" {
	type        = "string"
	description = "The AWS region to create resources in."
  	default     = "us-east-1"
}

#--------------------------------------------------------------
# Key File
#--------------------------------------------------------------
variable "key_file" {
	type        = "string"
	description = "describe your variable"
	default     = "ssh_keys/database_key.pub"
}

#--------------------------------------------------------------
# Availability Zones
#--------------------------------------------------------------
variable "azs" {
	type        = "string"
	description = "Availability Zones"
	default     = "us-east-1a,us-east-1b"
}

#--------------------------------------------------------------
# Public & Private CIDRs
#--------------------------------------------------------------
variable "public_cidrs" {
	type        = "string"
	description = "public network blocks"
	default     = "10.0.2.0/24,10.0.3.0/24"
}

variable "private_cidrs" {
	type        = "string"
	description = "private network blocks"
	default     = "10.0.0.0/24,10.0.1.0/24"
}
