variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cidr_vpc" {
  type    = string
  default = "10.0.0.0/16"
}

variable "cidr_public_subnet1" {
  type    = string
  default = "10.0.1.0/24"
}

variable "cidr_private_subnet1" {
  type    = string
  default = "10.0.2.0/24"
}

variable "cidr_public_subnet2" {
  type    = string
  default = "10.0.11.0/24"
}

variable "cidr_private_subnet2" {
  type    = string
  default = "10.0.22.0/24"
}

variable "availability_zone" {
  type = map(string)

  default = {
    az_a = "us-east-1a"
    az_b = "us-east-1b"
    az_c = "us-east-1c"
  }

}

variable "ami" {
  type    = string
  default = "ami-03ededff12e34e59e"

}

variable "instance_type" {
  type    = string
  default = "t2.micro"

}

variable "key_name" {
  type = string
  
}