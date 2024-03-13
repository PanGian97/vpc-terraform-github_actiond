output "vpc_id" {
    value = aws_vpc.my_vpc.id
}

output "pub_subnet_ids" {
    value = aws_subnet.pub_subnets.*.id
}
output "pri_subnet_ids" {
    value = aws_subnet.pri_subnets.*.id
}