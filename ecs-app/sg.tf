resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.ecs-app-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}