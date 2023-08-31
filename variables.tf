variable "aws_region" {
  type = string
  default = "us-west-2"  
}

variable "subdomain" {
  type = string
  default = "tchouetckeatankoua"   
}

variable "port" {
  type = number
  default = 80
}

variable "keypair" {
  type = string
  default = "nginx"  
}

variable "ami" {
  type = string
  default = "ami-0c79a55dda52434da"
}

variable "dns" {
  type = string
  default = "interview.exosite.biz"
}

variable "instance_type" {
  type = string
  default = "t4g.nano"
}


