// EC2 Instance Creation


locals {
  disable_api_termination = false
}

resource "aws_instance" "csye6225-ec2-instance" {

  ami                     = var.ami
  instance_type           = "t2.micro"
  disable_api_termination = local.disable_api_termination
  iam_instance_profile    = aws_iam_instance_profile.csye6225_profile.name
  key_name                = var.key_name
  user_data               = <<EOF
#!/bin/bash
sudo touch /home/ubuntu/.env
sudo echo "RDS_USERNAME=\"${aws_db_instance.db.username}\"" >> /home/ubuntu/.env
sudo echo "RDS_PASSWORD=\"${aws_db_instance.db.password}\"" >> /home/ubuntu/.env
sudo echo "RDS_HOSTNAME=\"${aws_db_instance.db.address}\"" >> /home/ubuntu/.env
sudo echo "RDS_AWS_BUCKET=\"${aws_s3_bucket.csye6225-bucket.bucket}\"" >> /home/ubuntu/.env
sudo echo "RDS_ENDPOINT=\"${aws_db_instance.db.endpoint}\"" >> /home/ubuntu/.env
sudo echo "RDS_DB_NAME=\"${aws_db_instance.db.name}\"" >> /home/ubuntu/.env
sudo echo "AWS_ACCESS_KEY=\"${var.access_key}\"" >> /home/ubuntu/.env
sudo echo "AWS_SECRET_KEY=\"${var.secret_key}\"" >> /home/ubuntu/.env
sudo echo "AWS_BUCKET_REGION=\"${var.region}\"" >> /home/ubuntu/.env
  EOF
  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }
  network_interface {
    network_interface_id = aws_network_interface.my-interface.id
    device_index         = 0
  }


  tags = {
    Name = "csye6225-ec2-instance"
  }

}