terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2" # London
}
resource "aws_key_pair" "generated_onms_key" {
  key_name   = "id_rsa_opennms"
  public_key = file("./id_rsa.pub")
}

# Generate random password for Postgre User
resource "random_password" "postgres_password" {
  length             = 20
  special            = true
  override_special   = "!#$%^&*~"  # Only valid special characters for RDS
  upper              = true
  lower              = true
}

# Generate random password for ONMS USER
resource "random_password" "ONMS_password" {
  length             = 20
  special            = true
  override_special   = "!#$%^&*~"  # Only valid special characters for RDS
  upper              = true
  lower              = true
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

# Public Subnet for Availability Zone A
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-a"
  }
}

# Public Subnet for Availability Zone B
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-b"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public_association_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_association_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# RDS Security Group (allow traffic from EC2 SG)
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port                = 5432
    to_port                  = 5432
    protocol                 = "tcp"
    security_groups         = [aws_security_group.ec2_sg.id]  # Corrected line: using security_groups instead of source_security_group_id
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.public_a.id, aws_subnet.public_b.id] # Adding two subnets for multiple AZ coverage
}

# RDS Instance
resource "aws_db_instance" "opennms_db" {
  identifier             = "opennms-db"
  engine                 = "postgres"
  engine_version         = "14.17"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = "postgre"
  password               = random_password.postgres_password.result
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name

  tags = {
    Name = "OpenNMS-DB"
  }
}

# Outputs
output "ec2_public_ip" {
  value = aws_instance.OpenNMS.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.opennms_db.endpoint
}

# Security Group for EC2 Instances
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }
  ingress {
    from_port   = 61616
    to_port     = 61616
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ONMS-ActiveMQ"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

# EC2 Instance with OpenNMS & K3s
resource "aws_instance" "OpenNMS" {
  ami                    = "ami-0a94c8e4ca2674d5a"
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.generated_onms_key.key_name

  user_data = templatefile("${path.module}/deploy.sh.tmpl", {
    postgres_host     = split(":", aws_db_instance.opennms_db.endpoint)[0]
    onms_password     = random_password.ONMS_password.result
    postgres_password = random_password.postgres_password.result
  })

  root_block_device {
    volume_size = 20           
    volume_type = "gp3"            
    delete_on_termination = true
  }

  tags = {
    Name = "OpenNMS"
  }
}
