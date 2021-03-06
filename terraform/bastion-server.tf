#--------------------------------------------------------------
# Bastion Artifact (AMI)
#-----------------------------------------1---------------------
data "atlas_artifact" "Bastion" {
  name    = "Panda/Bastion"
  type    = "amazon.image"
  version = "latest"
}

#--------------------------------------------------------------
# Bastion Instance
#--------------------------------------------------------------
resource "aws_instance" "bastion_server" {
  ami           = "${data.atlas_artifact.Bastion.metadata_full.region-us-east-1}"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.public.id}"

  security_groups = ["${aws_security_group.bastion_security.id}",
    "${aws_security_group.consul_security_group.id}",
    "${aws_security_group.primary.id}",
  ]

  key_name                    = "${module.ssh_keys.key_name}"
  depends_on                  = ["aws_internet_gateway.database_gateway", "aws_instance.consul_server"]
  monitoring                  = true
  associate_public_ip_address = true

  tags {
    Name = "bastion_host"
    role = "bastion"
  }

  connection {
    user        = "root"
    private_key = "${module.ssh_keys.private_key_path}"
  }
}
