output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "igw_id" {
  value = aws_internet_gateway.internet-gateway.id
}

output "route_table_id" {
  value = aws_route_table.public-route-table.id
}

output "db_endpoint" {
  value = aws_db_instance.db.endpoint
}

output "rds_hostname" {
  value = aws_db_instance.db.address
}

output "rds_port" {
  value = aws_db_instance.db.port
}

