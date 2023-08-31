resource "aws_security_group" "lb_sg" {
  name        = "lb-security-group"
  description = "Security group for Load Balancer"

  tags = {
    Name = "${local.resource_name_prefix}security-group"
  }
}

resource "aws_security_group_rule" "lb_http_rule" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "lb_https_rule" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "egress_rule" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"  
  cidr_blocks = ["0.0.0.0/0"]
  
  security_group_id = aws_security_group.lb_sg.id 
}
