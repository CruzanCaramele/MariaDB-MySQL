#--------------------------------------------------------------
# NAT AMI
#--------------------------------------------------------------
data "aws_ami" "nat_ami" {
	most_recent      = true

	filter {
		name    = "owner-alias"
		values = ["amazon"]
	}

	filter {
		name    = "name"
		values = ["amzn-ami-vpc-nat*"]
	}
}

#--------------------------------------------------------------
# NAT Instance
#--------------------------------------------------------------
resource "aws_instance" "nat_instance" {
	ami               = "${data.aws_ami.nat_ami.id}"
	instance_type     = "t2.micro"
	subnet_id         = "${aws_subnet.public.1.id}"
	monitoring        = true
	source_dest_check = true
	security_groups   = ["${aws_security_group.nat_instance_security_group.id}","${aws_security_group.consul_security_group.id}"]

	tags {
		Name = "NAT"
	} 
}