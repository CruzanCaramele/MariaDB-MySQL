#--------------------------------------------------------------
# Instance Ami(s)
#--------------------------------------------------------------
data "atlas_artifact" "MasterDB" {
	name    = "Panda/MasterDB"
	build   = "latest"
	type    = "amazon.image"
}

#--------------------------------------------------------------
# Instances
#--------------------------------------------------------------
resource "aws_instance" "database_backup" {
	ami           		 = "${data.aws_ami.instance_ami.id}"
	instance_type 	 	 = "t2.micro"
	subnet_id     		 = "${aws_subnet.private.0.id}"
	monitoring           = true
	key_name             = "${aws_key_pair.database_key.key_name}"
	security_groups      = ["${aws_security_group.database_backup_security_group.id}"]
	iam_instance_profile = "${aws_iam_instance_profile.instance_profile.id}"

	tags {
		Name = "backup_backup"
	}
}

resource "aws_instance" "database_slave" {
	ami             = "${data.aws_ami.instance_ami.id}"
	instance_type   = "t2.micro"
	subnet_id       = "${aws_subnet.private.1.id}"
	monitoring      = true
	key_name        = "${aws_key_pair.database_key.key_name}"
	security_groups = ["${aws_security_group.database_master_security_group.id}"] 

	tags {
		Name = "database_slave"
	}
}

resource "aws_instance" "database_master" {
	ami             = "${data.atlas_artifact.MasterDB.metadata_full.region-us-east-1}"
	instance_type   = "t2.micro"
	subnet_id       = "${aws_subnet.private.1.id}"
	monitoring      = true
	key_name        = "${aws_key_pair.database_key.key_name}"
	security_groups = ["${aws_security_group.database_master_security_group.id}"] 

	tags {
		Name = "database_master"
	}
}