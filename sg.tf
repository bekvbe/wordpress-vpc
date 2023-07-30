resource "aws_security_group" "wordpress-sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = aws_vpc.word_press_vpc.id
  ingress {
    description = "HTTP Traffic over port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH Traffic over port 80"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Outbound Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "wordpress-sg"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "RDS-sg"
  description = var.rds_description
  vpc_id      = aws_vpc.word_press_vpc.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
