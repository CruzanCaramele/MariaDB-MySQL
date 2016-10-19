#--------------------------------------------------------------
# Bastion Ami
#--------------------------------------------------------------
data "aws_ami" "bastion_ami" {
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
# Bastion Instance
#--------------------------------------------------------------
resource "aws_instance" "bastion_server" {
	ami             = "${data.aws_ami.bastion_ami.id}"
	instance_type   = "t2.micro"
	subnet_id       = "${aws_subnet.public_subnet.1.id}"
	security_groups = ["${aws_security_group.bastion_security.id}"]
	key_name        = "${aws_key_pair.database_key.key_name}"
	monitoring      = true

	tags {
		Name = "bastion_host"
	}

	provisioner "file" {
		source      = "scripts/firewalld.sh"
		destination = "/tmp/firewalld.sh"
	}

	provisioner "remote-exec" {
		inline = [
			"chmod +x /tmp/firewalld.sh"
			"bash /tmp/firewalld.sh"
		]
	}
}