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
    filename         = "${path.module}/../ec2-key"
    file_permission  = "0600"
}

resource "aws_instance" "flask_app" {
    ami                    = "ami-0a313d6098716f372"  
    instance_type          = "t3.medium"         
    key_name               = aws_key_pair.ec2_key.key_name
    vpc_security_group_ids = [aws_security_group.flask_app_sg.id]

    root_block_device {
    volume_size = 7        # 7 GB disk
    volume_type = "gp3"    # General Purpose SSD
    delete_on_termination = true
    }
}

resource "aws_eip" "app_eip" {
    instance = aws_instance.flask_app.id
}

resource "local_file" "ansible_inventory" {
    filename = "${path.module}/../ansible/inventory.ini"
    content  = <<EOT
    [webservers]
    ${aws_eip.app_eip.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=../ec2-key
    EOT
    file_permission = "0644"
    
    depends_on = [aws_eip.app_eip]
}
