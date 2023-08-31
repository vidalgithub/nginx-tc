resource "aws_route53_record" "subdomain" {
  zone_id = local.zone_id
  name    = "${var.subdomain}" 
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.load_balancer.dns_name]
}


resource "aws_lb" "load_balancer" {
  name               = "nginx-alb"
  load_balancer_type = "application"
  security_groups    = [
    aws_security_group.lb_sg.id
  ]

  subnets = [
    local.subnet_ids[0],
    local.subnet_ids[1]
  ]

  enable_deletion_protection = false

  tags = {
    Name = "${local.resource_name_prefix}nginx-alb"
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn 
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Name = "${local.resource_name_prefix}http-listener"
  }
}


resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      =  "ELBSecurityPolicy-2016-08"
  certificate_arn =  data.aws_acm_certificate.example_certificate.arn

  default_action {
    type            = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

  tags = {
    Name = "${local.resource_name_prefix}https-listener"
  }
}


resource "aws_lb_target_group" "nginx" {
  name     = "nginx-target-group"
  port     = var.port
  protocol = "HTTP"
  vpc_id   = local.vpc_id 

  tags = {
    Name = "${local.resource_name_prefix}target-group"
  }
}


resource "aws_instance" "nginx_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = local.subnet_ids[1]
  key_name      = var.keypair
  security_groups = [
    aws_security_group.lb_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y 
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable ngnix
              echo "Welcome to Nginx Mr. tchouetckeatankoua, from Exosite." > /var/www/html/index.html
              EOF

  tags = {
    Name = "${local.resource_name_prefix}nginx-server"
  }
}


resource "aws_lb_target_group_attachment" "nginx_instance_attachment" {
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx_instance.id
  port             = var.port
}


resource "aws_lb_listener_rule" "nginx" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

  condition {
    host_header {
      values = ["${local.domain_name}"]
    }
  }

  tags = {
    Name = "${local.resource_name_prefix}lb-listener-rule"
  }
}


locals {
  resource_name_prefix = "tcta_"
  vpc_id = "vpc-0c2a36846ba20e729"
  subnet_ids = [
    "subnet-0068679226e81966f",
    "subnet-0db7119e20b440c97",
    "subnet-056f4097e702e48ac",
    "subnet-07c4289662cca87e6",

  ]
  domain_name = "tchouetckeatankoua.interview.exosite.biz"
  zone_id     = "Z0900350IRBV4VB1AT02"
} 







