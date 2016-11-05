#--------------------------------------------------------------
# Bastion Artifact (AMI)
#--------------------------------------------------------------
resource "aws_vpc" "database_setup" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "database_setup"
  }
}

#--------------------------------------------------------------
# Internet Gateway
#--------------------------------------------------------------
resource "aws_internet_gateway" "database_gateway" {
  vpc_id = "${aws_vpc.database_setup.id}"

  tags {
    Name = "database_internet_gateway"
  }
}

#--------------------------------------------------------------
# Private subnet
#--------------------------------------------------------------
resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.database_setup.id}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  cidr_block        = "${element(split(",", var.private_cidrs), count.index)}"
  count             = "${length(compact(split(",", var.private_cidrs)))}"
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.database_setup.id}"
  count  = "${length(split(",", var.azs))}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.database_nat.*.id, count.index)}"
  }

  tags {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = "${length(compact(split(",", var.private_cidrs)))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private_route_table.*.id, count.index)}"
}

#--------------------------------------------------------------
# NAT Eip
#--------------------------------------------------------------
resource "aws_eip" "database_nat_eip" {
  vpc   = true
  count = "${length(split(",", var.azs))}"
}

#--------------------------------------------------------------
# NAT Gateway
#--------------------------------------------------------------
resource "aws_nat_gateway" "database_nat" {
  count         = "${length(split(",", var.azs))}"
  allocation_id = "${element(aws_eip.database_nat_eip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
}

#--------------------------------------------------------------
# Public subnet
#--------------------------------------------------------------
resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.database_setup.id}"
  availability_zone       = "us-east-1a"
  cidr_block              = "${var.public_cidrs}"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.database_setup.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.database_gateway.id}"
  }

  tags {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}
