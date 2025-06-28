provider "aws" {
    region = "eu-north-1"
}

resource "aws_security_group" "adcash_sg" {
    name        = "adcash-sg"

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
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

resource "aws_key_pair" "adcash_key" {
    key_name   = "adcash-key"
    public_key = file(".ssh/adcash_key.pub") 
}

resource "aws_instance" "adcash_vm" {
    ami           = "ami-042b4708b1d05f512"
    instance_type = "t3.micro"
    security_groups = [aws_security_group.adcash_sg.name]
    key_name        = aws_key_pair.adcash_key.key_name

    tags = {
        Name = "adcash-vm"
    }
}

resource "aws_eip" "adcash_eip" {
    instance = aws_instance.adcash_vm.id
}
