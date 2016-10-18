#--------------------------------------------------------------
# bastion Server Security Group
#--------------------------------------------------------------
resource "aws_security_group" "bastion_security" {
	name        = "bastion-security"
	description = "Security group for bastion instance"
	vpc_id      = "${aws_vpc.database_setup.id}"

	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

  	tags {
  		Name = "bastion-server-security"
  	}

	lifecycle {
		create_before_destroy = true
	}
}