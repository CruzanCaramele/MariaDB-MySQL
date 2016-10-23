#--------------------------------------------------------------
# Route53 Hosted Zone
#--------------------------------------------------------------
resource "aws_route53_zone" "hosted_zone" {
	name   = "prod.internal"
	vpc_id = "${aws_vpc.database_setup.id}"

	tags {
		Name = "production-zone"
	}
}

#--------------------------------------------------------------
# Route53 Records
#--------------------------------------------------------------
resource "aws_route53_record" "backup_instance_record" {
	zone_id = "${aws_route53_zone.hosted_zone.id}"
	name     = "backup.prod.internal"
	type     = "A"
	records  = ["aws_instance.database_backup.private_ip"]
}

resource "aws_route53_record" "slave_instance_record" {
	zone_id = "${aws_route53_zone.hosted_zone.id}"
	name     = "slave.prod.internal"
	type     = "A"
	records  = ["aws_instance.database_slave.private_ip"]
}

resource "aws_route53_record" "master_instance_record" {
	zone_id = "${aws_route53_zone.hosted_zone.id}"
	name     = "master.prod.internal"
	type     = "A"
	records  = ["aws_instance.database_master.private_ip"]
}