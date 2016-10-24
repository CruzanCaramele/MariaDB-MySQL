#--------------------------------------------------------------
# Bastion Instance
#--------------------------------------------------------------
resource "aws_instance" "bastion_server" {
	ami             			= "${data.aws_ami.instance_ami.id}"
	instance_type   			= "t2.micro"
	subnet_id       			= "${aws_subnet.public.1.id}"
	security_groups 			= ["${aws_security_group.bastion_security.id}"]
	key_name        			= "${aws_key_pair.database_key.key_name}"
	monitoring      			= true
	associate_public_ip_address = true

	tags {
		Name = "bastion_host"
	}

	connection {
		type     = "ssh"
		user     = "root"
		key_file = "${file("ssh_keys/id_rsa.pem")}"
	}

	provisioner "file" {
		source      = "scripts/firewalld.sh"
		destination = "/tmp/firewalld.sh"
	}

	provisioner "remote-exec" {
		inline = [
			"chmod +x /tmp/firewalld.sh",
			"bash /tmp/firewalld.sh"
		]
	}
}