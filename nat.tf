#--------------------------------------------------------------
# NAT AMI
#--------------------------------------------------------------
data "aws_ami" "nat_ami" {
	most_recent      = true
	executable_users = self

	filter {
		name    = "owner-alias"
		valeues = ["amazon"]
	}

	filter {
		name    = "name"
		valeues = ["amzn-ami-vpc-nat*"]
	}
}

#--------------------------------------------------------------
# NAT Instance
#--------------------------------------------------------------
resource "aws_instance" "nat_instance" {
	ami             = "${data.aws_ami.nat_ami.id}"
	instance_type   = "t2.micro"
	subnet_id       = "${aws_subnet.public.2.id}"
	monitoring      = true
	key_name        = "${aws_key_pair.database_key.key_name}"
	security_groups = ["${aws_security_group.nat_instance_security_group.id}"]

	tags {
		Name = "NAT"
	} 
}