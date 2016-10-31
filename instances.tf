#--------------------------------------------------------------
# Instance Ami(s)
#--------------------------------------------------------------
data "atlas_artifact" "MasterDB" {
	name    = "Panda/MasterDB"
	type    = "amazon.image"
	version = "latest"
}

data "atlas_artifact" "SlaveDB" {
	name    = "Panda/SlaveDB"
	type    = "amazon.image"
	version = "latest"
}

data "atlas_artifact" "backup_database_ami" {
	name    = "Panda/BackupDB"
	type    = "amazon.image"
	version = "latest"
}

#--------------------------------------------------------------
# Instances
#--------------------------------------------------------------
resource "aws_instance" "database_backup" {
	ami           		 = "${data.atlas_artifact.backup_database_ami.metadata_full.region-us-east-1}"
	instance_type 	 	 = "t2.micro"
	subnet_id     		 = "${aws_subnet.private.0.id}"
	monitoring           = true
	key_name             = "${module.ssh_keys.key_name}"
	depends_on           = ["aws_instance.database_slave"]
	security_groups      = ["${aws_security_group.database_backup_security_group.id}","${aws_security_group.consul_security_group.id}"]
	iam_instance_profile = "${aws_iam_instance_profile.instance_profile.id}"

	tags {
		Name = "backup_database"
	}

	connection {
		user        = "root"
		private_key = "${module.ssh_keys.private_key_path}"
	}
}

resource "aws_instance" "database_slave" {
	ami             = "${data.atlas_artifact.SlaveDB.metadata_full.region-us-east-1}"
	instance_type   = "t2.micro"
	subnet_id       = "${aws_subnet.private.1.id}"
	monitoring      = true
	key_name        = "${module.ssh_keys.key_name}"
	depends_on      = ["aws_instance.database_master"]
	security_groups = ["${aws_security_group.database_master_security_group.id}","${aws_security_group.consul_security_group.id}"] 

	tags {
		Name = "database_slave"
	}

	connection {
		user        = "root"
		private_key = "${module.ssh_keys.private_key_path}"
	}	
}

resource "aws_instance" "database_master" {
	ami             = "${data.atlas_artifact.MasterDB.metadata_full.region-us-east-1}"
	instance_type   = "t2.micro"
	subnet_id       = "${aws_subnet.private.1.id}"
	monitoring      = true
	key_name        = "${module.ssh_keys.key_name}"
	depends_on      = ["aws_instance.bastion_server"]
	security_groups = ["${aws_security_group.database_master_security_group.id}","${aws_security_group.consul_security_group.id}"] 

	tags {
		Name = "database_master"
	}

	connection {
		user        = "centos"
		private_key = "${module.ssh_keys.private_key_path}"
	}	
}