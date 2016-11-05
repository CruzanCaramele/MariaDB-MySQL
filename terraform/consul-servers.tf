#--------------------------------------------------------------
# Bastion Artifact (AMI)
#-----------------------------------------1---------------------
data "atlas_artifact" "Consul" {
  name    = "Panda/Consul-Server"
  type    = "amazon.image"
  version = "latest"
}

#--------------------------------------------------------------
# Bastion Instance
#--------------------------------------------------------------
resource "aws_instance" "consul_server" {
  ami           = "${data.atlas_artifact.Consul.metadata_full.region-us-east-1}"
  count         = 3
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.private.0.id}"

  security_groups = ["${aws_security_group.consul_security_group.id}",
    "${aws_security_group.primary.id}",
  ]

  key_name   = "${module.ssh_keys.key_name}"
  depends_on = ["aws_internet_gateway.database_gateway"]
  monitoring = true
  private_ip = "${lookup(var.ips,count.index)}"

  tags {
    Name = "consul_server"
    role = "consul_leader"
  }

  connection {
    user        = "root"
    private_key = "${module.ssh_keys.private_key_path}"
  }
}
