#--------------------------------------------------------------
# Instances' KeyPair "${file(\"ssh_keys/sonar.pub\")}"
#--------------------------------------------------------------
resource "aws_key_pair" "database_key" {
	key_name   = "database_key"
	public_key = "${file("ssh_keys/sonar.pub")}"
}