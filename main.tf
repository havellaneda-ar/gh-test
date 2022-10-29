provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "github-runner-test" {
    vpc_security_group_ids = [aws_security_group.security_group.id]
    ami = "ami-0149b2da6ceec4bb0"
    instance_type = "t2.micro"
    user_data = <<EOF
#!/bin/bash

cd /home/ubuntu

  # Download the latest runner package
curl -o actions-runner-linux-x64-2.298.2.tar.gz -L https://github.com/actions/runner/releases/download/v2.298.2/actions-runner-linux-x64-2.298.2.tar.gz

  # Validate the hash
echo "0bfd792196ce0ec6f1c65d2a9ad00215b2926ef2c416b8d97615265194477117  actions-runner-linux-x64-2.298.2.tar.gz" | shasum -a 256 -c

  # Extract the installer
tar xzf ./actions-runner-linux-x64-2.298.2.tar.gz
 
  # Download the personal code to connect github
curl -o personal.token -L https://raw.githubusercontent.com/havellaneda-ar/gh-test/main/personal.code
token=$(cat personal.token| base64 --decode)

# Create the runner and start the configuration experience
curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $token" \
  https://api.github.com/repos/havellaneda-ar/gh-test/actions/runners/registration-token > token_output.txt

token_runner=$(cat token_output.txt | grep -w "token" | cut -d'"' -f4)

/bin/su -c "./config.sh --url https://github.com/havellaneda-ar/gh-test --token $token_runner --unattended" - ubuntu | tee ./config-data.log
/bin/su -c "./run.sh" - ubuntu | tee ./run-data.log 
  
EOF
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
