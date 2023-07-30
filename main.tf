resource "aws_instance" "wordpress-ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "wordpress-ec2"
  }
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.wordpress-sg.id]
  subnet_id                   = aws_subnet.public_subnet_1.id

}
resource "aws_key_pair" "deployer" {
  key_name   = "Linux.pem"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCMRW508/jN3XaZhevqj5Qj+Ep0esGrlw2n43FIYVdIWCF2ifOOvMi8l9QP5EqCfPQOCYW+pIVptIXLl5aG+Mc3+gKvYl6/XUKSLbeqwd+V8WbjofYsretF5iBWS7C3+CitIDwCSrhX/0VDkU4bSDv+u9wTgkXrrJ5RVGYqRdGqRqdu9+swsHx+cQmhmaYLIn7PVZZ29qHmKdqlatpLYILEuqGcar6nXv0I/2VRG4QJK5w87fD0bejRcEDCi/rNDwTVONJC19qaFcoquPYfzA2tZw1c/O47DGiqLzDeBwNI+02s2xygkf5nfqYMNFNiPMKKhjoZiB40SmVSf7Q6HJdZ"
}

resource "aws_db_instance" "db_instance" {
  identifier                  = "mydb"
  allocated_storage           = 20
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = "db.t2.micro"
  username                    = "admin"
  password                    = "adminadmin"
  multi_az                    = false
  db_name                     = "mydb"
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]
  storage_type                = "gp2"
  skip_final_snapshot         = true
  db_subnet_group_name        = aws_db_subnet_group.private_db_subnet_group.name
  depends_on                  = [aws_security_group.rds_sg]
  parameter_group_name        = "default.mysql8.0"
  allow_major_version_upgrade = true
}
