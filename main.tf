provider "aws" {
  region = "${var.region}"
}
resource "aws_vpc" "Terra_vpc" {
  cidr_block = "${var.vpc_cidr_block}"
  instance_tenancy = "default"
  tags {
    Name = "${var.vpc-nametag}"
  }
}
data "aws_availability_zones" "available_az" {
}

resource "aws_subnet" "public_subnet" {
  count = "${var.azs_count}"
  vpc_id = "${aws_vpc.Terra_vpc.id}"
  availability_zone = "${data.aws_availability_zones.available_az.names[count.index]}"
  cidr_block = "${cidrsubnet(aws_vpc.Terra_vpc.cidr_block, 8, count.index)}"
  map_public_ip_on_launch = "true"
  tags {
    Name = "${var.public-sub-tag}"
  }
}
resource "aws_subnet" "private_subnet" {
  count = "${var.azs_count}"
  vpc_id = "${aws_vpc.Terra_vpc.id}"
  availability_zone = "${data.aws_availability_zones.available_az.names[count.index]}"
  cidr_block = "${cidrsubnet(aws_vpc.Terra_vpc.cidr_block, 8, count.index+4)}"
  map_public_ip_on_launch = "false"
  tags {
    Name = "${var.private-sub-tag}"
  }
}

resource "aws_eip" "EIP-NG" {
  vpc = true
}
resource "aws_nat_gateway" "NG" {
  allocation_id = "${aws_eip.EIP-NG.id}"
  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
}

resource "aws_internet_gateway" "IG" {
  vpc_id = "${aws_vpc.Terra_vpc.id}"
}

resource "aws_route_table" "route_IG" {
  vpc_id = "${aws_vpc.Terra_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IG.id}"
  }
  tags {
    Name = "terra_route_IG"
  }
}
resource "aws_route_table_association" "route_public_sub" {
  count = "${var.azs_count}"
  route_table_id = "${aws_route_table.route_IG.id}"
  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
}

resource "aws_route_table" "route_NG" {
  vpc_id = "${aws_vpc.Terra_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.NG.id}"
  }
  tags {
    Name = "terra_route_NG"
  }
}
resource "aws_route_table_association" "route_private_sub" {
  count = "${var.azs_count}"
  route_table_id = "${aws_route_table.route_NG.id}"
  subnet_id = "${element(aws_subnet.private_subnet.*.id, count.index)}"
}
