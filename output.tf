output "vpc-id" {
  value = "${aws_vpc.Terra_vpc.id}"
}
output "public-subnetID" {
  value = "${aws_subnet.public_subnet.*.id}"
}
output "private-subnetID" {
  value = "${aws_subnet.private_subnet.*.id}"
}
output "Internet-gatewayID" {
  value = "${aws_internet_gateway.IG.id}"
}
output "Nat-gatewayID" {
  value = "${aws_nat_gateway.NG.id}"
}
output "public-routeID" {
  value = "${aws_route_table.route_IG.id}"
}
output "private-routeID" {
  value = "${aws_route_table.route_NG.id}"
}