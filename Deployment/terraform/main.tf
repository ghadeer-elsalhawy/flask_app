resource "tls_private_key" "ec2_private_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
    key_name   = "ec2-key"
    public_key = tls_private_key.ec2_private_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
    content          = tls_private_key.ec2_private_key.private_key_pem
    filename         = "${path.module}/../ec2-key.pem"
    file_permission  = "0600"
}

resource "aws_instance" "flask_app" {
    ami                    = "ami-0c94855ba95c71c99"  
    instance_type          = "t2.micro"          
    key_name               = aws_key_pair.ec2_key.key_name
    vpc_security_group_ids = [aws_security_group.flask_app_sg.id]
}

resource "aws_eip" "app_eip" {
    instance = aws_instance.flask_app.id
}

resource "local_file" "ansible_inventory" {
    filename = "${path.module}/../ansible/inventory.ini"
    content  = <<EOT
    [webservers]
    ${aws_eip.app_eip.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=../ec2-key.pem
    EOT
    file_permission = "0644"
    
    depends_on = [aws_eip.app_eip]
}
