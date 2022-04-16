resource "aws_security_group" "sg_ec2_ssh" {
  name        = "sg_ec2_public"
  description = "allow access ssh from everywhere"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "ssh from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = [var.cidr_vpc]
  }

}

resource "aws_security_group" "sg_ec2_private" {
  name        = "sg_ec2_http/https"
  description = "allow access http"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "http from lb"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https from lb"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "all from vpc"
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = [var.cidr_vpc]
  }

  ingress {
    description = "ssh from my VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_vpc]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }


}



resource "aws_security_group" "sg_lb" {
  name        = "sg_lb"
  description = "http access to load balancer"
  vpc_id      = aws_vpc.main_vpc.id
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "all"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_security_group" "default" {
  name        = "default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.main_vpc.id
  depends_on  = [aws_vpc.main_vpc]
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
  tags = {
    Name = "default-sg"
  }
}