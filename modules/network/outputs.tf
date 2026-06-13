output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = [aws_subnet.pub_sub_a.id, aws_subnet.pub_sub_b.id]
}