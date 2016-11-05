#--------------------------------------------------------------
# Primary Security Group
#--------------------------------------------------------------
resource "aws_security_group" "primary" {
	name        = "primary-security"
	description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
	vpc_id      = "${aws_vpc.database_setup.id}"

    // allows traffic from the SG itself for tcp
    ingress {
        from_port = 0
        to_port   = 65535
        protocol  = "tcp"
        self      = true
    }

    // allows traffic from the SG itself for udp
    ingress {
        from_port = 0
        to_port   = 65535
        protocol  = "udp"
        self      = true
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }  
}

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

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

  	tags {
  		Name = "bastion-server-security"
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
		cidr_blocks     = ["10.0.2.0/24","10.0.3.0/24","10.0.0.0/24","10.0.1.0/24"]
	}

	egress {
		from_port   	= 0
		to_port     	= 0
		protocol    	= "-1"
		cidr_blocks 	= ["0.0.0.0/0"]
	}
}

#--------------------------------------------------------------
# Database Master Instances' Security Group
#--------------------------------------------------------------
resource "aws_security_group" "database_master_security_group" {
	name        = "database_master_security_group"
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
		cidr_blocks     = ["10.0.2.0/24","10.0.3.0/24","10.0.0.0/24","10.0.1.0/24"]
	}

	egress {
		from_port       = 0
		to_port         = 0
		protocol        = "-1"
		cidr_blocks     = ["0.0.0.0/0"]
	}
}


#--------------------------------------------------------------
# Consul Security Group
#--------------------------------------------------------------
resource "aws_security_group" "consul_security_group" {
    name        = "consul_security_group"
    description = "Security Group for consul"
    vpc_id      = "${aws_vpc.database_setup.id}"

    // allows traffic from the SG itself for tcp
    ingress {
        from_port = 0
        to_port   = 65535
        protocol  = "tcp"
        self      = true
    }

    // allows traffic from the SG itself for udp
    ingress {
        from_port = 0
        to_port   = 65535
        protocol  = "udp"
        self 	  = true
    }

    // allow traffic for TCP 22 (SSH)
    ingress {
        from_port 	= 22
        to_port 	= 22
        protocol 	= "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
       

    // allow traffic for TCP 8300 (Server RPC)
    ingress {
        from_port 	= 8300
        to_port 	= 8300
        protocol 	= "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // allow traffic for TCP 8301 (Serf LAN)
    ingress {
        from_port 	= 8301
        to_port 	= 8301
        protocol 	= "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // allow traffic for UDP 8301 (Serf LAN)
    ingress {
        from_port   = 8301
        to_port     = 8301
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // allow traffic for TCP 8400 (Consul RPC)
    ingress {
        from_port   = 8400
        to_port     = 8400
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // allow traffic for TCP 8500 (Consul Web UI)
    ingress {
        from_port   = 8500
        to_port     = 8500
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // allow traffic for TCP 8600 (Consul DNS Interface)
    ingress {
        from_port   = 8600
        to_port     = 8600
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // allow traffic for UDP 8600 (Consul DNS Interface)
    ingress {
        from_port   = 8600
        to_port     = 8600
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}