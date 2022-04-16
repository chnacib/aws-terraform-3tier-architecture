
resource "aws_instance" "ec2_public_2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone.az_b
  subnet_id                   = aws_subnet.public_subnet2.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.sg_ec2_ssh.id]
  key_name                    = var.key_name
  provisioner "file" {
    source      = var.key_name
    destination = "/tmp/${var.key_name}.pem"

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("${var.key_name}.pem")

    }
  }
  depends_on = [aws_nat_gateway.nat_gw]


}

resource "aws_instance" "ec2_private_2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone.az_b
  subnet_id                   = aws_subnet.private_subnet2.id
  associate_public_ip_address = false
  security_groups             = [aws_security_group.default.id, aws_security_group.sg_ec2_private.id]
  key_name                    = var.key_name
  user_data                   = <<EOF
              #! /bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl enable httpd
              sudo systemctl start httpd
              EOF



  depends_on = [aws_nat_gateway.nat_gw]
}

resource "aws_instance" "ec2_private_1" {
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone.az_a
  subnet_id                   = aws_subnet.private_subnet1.id
  associate_public_ip_address = false
  security_groups             = [aws_security_group.sg_ec2_private.id, aws_security_group.default.id]
  key_name                    = var.key_name
  user_data                   = <<EOF
    #! /bin/bash
    # Instance Identity Metadata Reference - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl enable httpd
    sudo service httpd start  
    sudo echo '<h1>Welcome to APP1 - APP-1</h1>' | sudo tee /var/www/html/index.html
    sudo mkdir /var/www/html/app1
    sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - APP-1</h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
              EOF

  depends_on = [aws_nat_gateway.nat_gw]
}


