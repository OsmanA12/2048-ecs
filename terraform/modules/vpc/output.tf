output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_a_id" {
  value = aws_subnet.main.id
}

output "subnet_b_id" {
  value = aws_subnet.main2.id
}

output "security_group_id" {
  value = aws_security_group.default.id
}

output "subnets_id" {
    value = [aws_subnet.main.id, aws.subnet.main2.id]
}