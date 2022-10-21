provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "github-runner-test" {
    vpc_security_group_ids = [aws_security_group.security_group.id]
    ami = var.ami_id
    instance_type = var.instance_type
    user_data = templatefile("scripts/ec2.sh", "ALNIP2JZ7MDFFHM2WS7BC2DDKMN4A")
    tags= var.tags 
}


resource "aws_security_group" "security_group" {
    name = "sec_group_github_runner"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
