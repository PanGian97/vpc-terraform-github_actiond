resource "aws_security_group" "sg_alb" {
  name        = "sg_alb"
  description = "Allow HTTP, SSH inbound traffic for load balancer"
  vpc_id      = var.vpc_id

depends_on = [ var.vpc_id]
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-alb"
  }
}
resource "aws_security_group" "sg_pri" {
  name        = "sg_pri"
  description = "Allow HTTP, SSH inbound traffic from load balancer"
  vpc_id      = var.vpc_id

depends_on = [ var.vpc_id]
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.sg_alb.id]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.sg_alb.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-pri"
  }
}