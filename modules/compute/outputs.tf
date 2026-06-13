output "autoscaling_group_name" {
  description = "Nome do Auto Scaling Group criado"
  value       = aws_autoscaling_group.app_asg.name
}

output "compute_security_group_id" {
  description = "ID do Security Group das instâncias EC2"
  value       = aws_security_group.ec2_sg.id
}