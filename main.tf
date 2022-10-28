provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "github-runner-test" {
    vpc_security_group_ids = [aws_security_group.security_group.id]
    ami = "ami-08c40ec9ead489470"
    instance_type = "t2.micro"
    user_data = templatefile("scripts/ec2.sh", {PERSONAL_ACCESS_TOKEN = $GITHUB_TOKEN})
    tags= {Name = "github-runner", Type = "terraform"}
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
