resource "aws_security_group" "rds" {
  name_prefix = "rds-"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_subnet_group" "boutique" {
  name       = "boutique-db-subnet"
  subnet_ids = module.vpc.private_subnets
}
resource "aws_db_instance" "boutique" {
  identifier             = "boutique-db"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "boutique"
  username               = "boutiqueuser"
  password               = "Boutique123!"
  db_subnet_group_name   = aws_db_subnet_group.boutique.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
}