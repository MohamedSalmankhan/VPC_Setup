variable "region" {
  default = "us-east-1"
}
variable "vpc-cidr-block" {
  default = "10.10.0.0/16"
}
variable "azs-count" {
}
variable "vpc-nametag" {
  default = "Ebiz_Terra_vpc"
}
variable "public-sub-tag" {
  default = "Ebiz_public_sub"
}
variable "private-sub-tag" {
  default = "Ebiz_private_sub"
}
