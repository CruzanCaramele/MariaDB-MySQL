#--------------------------------------------------------------
# Instance Ami
#--------------------------------------------------------------
data "aws_ami" "instance_ami" {
	most_recent = true

	filter {
		name   = "virtualization-type"
		values = ["hvm"]
	}

	filter {
		name   = "product-code"
		values = ["aw0evgkw8e5c1q413zgy5pjce"]
	}

	filter {
		name   = "name"
		values = ["CentOS-7x86_64"]
	}

	owners = ["amazon"]
}

#--------------------------------------------------------------
# Instance
#--------------------------------------------------------------
