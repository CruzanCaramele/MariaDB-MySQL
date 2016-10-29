#--------------------------------------------------------------
# Bastion Artifact (AMI)
#--------------------------------------------------------------
data "atlas_artifact" "Bastion" {
	name    = "Panda/Bastion"
	build   = "latest"
	type    = "amazon.image"
}

#--------------------------------------------------------------
# Bastion Instance
#--------------------------------------------------------------
resource "aws_instance" "bastion_server" {
	ami             			= "${data.atlas_artifact.Bastion.metadata_full.region-us-east-1}"
	instance_type   			= "t2.micro"
	subnet_id       			= "${aws_subnet.public.1.id}"
	security_groups 			= ["${aws_security_group.bastion_security.id}"]
	key_name        			= "${aws_key_pair.database_key.key_name}"
	depends_on                  = ["aws_internet_gateway.database_gateway"]
	monitoring      			= true
	associate_public_ip_address = true

	tags {
		Name = "bastion_host"
		role = "bastion"
	}

	connection {
		user     = "centos"
		key_file = "${file("ssh_keys/database_key.pem")}" 
	}
}