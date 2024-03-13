variable "vpc_cidr" {
  description = "VPC CIDR Range"
  type = string
}

variable "pub_subnet_cidr" {
    description = "Public Subnet CIDRS"
    type = list(string)
}
variable "pri_subnet_cidr" {
    description = "Private Subnet CIDRS"
    type = list(string)
}