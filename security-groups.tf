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
		cidr_blocks = ["61.6.109.231/32"]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

  	tags {
  		Name = "bastion-server-security"
  	}

	lifecycle {
		create_before_destroy = true
	}
}

#--------------------------------------------------------------
# Database Backup Instances' Security Group
#--------------------------------------------------------------
resource "aws_security_group" "database_backup_security_group" {
	name        = "database_backup_security_group"
	description = "Security group for ec2 slave database instances"
	vpc_id      = "${aws_vpc.database_setup.id}"

	ingress {
		from_port       = 22
		to_port         = 22
		protocol        = "tcp"
		security_groups = ["${aws_security_group.bastion_security.id}"]
	}

	ingress {
		from_port       = 3306
		to_port         = 3306
		protocol        = "tcp"
		cidr_blocks     = ["10.0.2.0/24,10.0.3.0/24,10.0.0.0/24,10.0.1.0/24"]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

#--------------------------------------------------------------
# Database Master Instances' Security Group
#--------------------------------------------------------------
resource "aws_security_group" "database_master_security_group" {
	name        = "database_backup_security_group"
	description = "Security group for ec2 master database instances"
	vpc_id      = "${aws_vpc.database_setup.id}"

	ingress {
		from_port       = 22
		to_port         = 22
		protocol        = "tcp"
		security_groups = ["${aws_security_group.bastion_security.id}"]
	}

	ingress {
		from_port       = 3306
		to_port         = 3306
		protocol        = "tcp"
		cidr_blocks     = ["10.0.2.0/24,10.0.3.0/24,10.0.0.0/24,10.0.1.0/24"]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

#--------------------------------------------------------------
# NAT Instance Security Group
#--------------------------------------------------------------
resource "aws_security_group" "nat_instance_security_group" {
	name        = "nat_instance_security_group"
	description = "Security group for NAT instance"
	vpc_id      = "${aws_vpc.database_setup.id}"

	ingress {
		from_port       = 22
		to_port         = 22
		protocol        = "tcp"
		security_groups = ["${aws_security_group.bastion_security.id}"]
	}

	ingress {
		from_port       = 80
		to_port         = 80
		protocol        = "tcp"
		cidr_blocks     = ["10.0.0.0/24,10.0.1.0/24"]
	}

	ingress {
		from_port       = 443
		to_port         = 443
		protocol        = "tcp"
		cidr_blocks     = ["10.0.0.0/24,10.0.1.0/24"]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}