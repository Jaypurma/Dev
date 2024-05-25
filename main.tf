resource "aws_instance" "instance" {
  ami           = var.image
  instance_type = var.type
  tags = {
    name = var.tag
  }
  key_name ="jaya"
  vpc_security_group_ids      = [aws_security_group.sandbox_sg.id]
  associate_public_ip_address = true
provisioner "remote-exec" {
   inline = ["sudo apt install apache2 -y", "sudo service apache2 start","echo '<html><body><h1>HeLLo from $(hostname)</h1></body></html>' | sudo tee /var/www/html/index.html"]
}

connection {
  host = self.public_ip
  user = var.login_user 
  private_key = file("jaya.pem")
    }


}

resource "aws_security_group" "sandbox_sg" {
  name   = "sandbox security group"
  vpc_id = var.vpc.id

  ingress {
    description = "inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc.cidr]
  }
ingress {
    description = "inbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc.cidr]
  }

  egress {
    description = "outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [var.vpc.cidr]
  }

  tags = {
    sg_name = "sandbox-security-group"
  }

}