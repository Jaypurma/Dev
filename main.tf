resource "aws_instance" "instance" {
  ami           = var.image
  instance_type = var.type
  subnet_id     = aws_subnet.main.id
  tags = {
    name = var.tag
  }
  key_name               = "jaya"
  vpc_security_group_ids = [aws_security_group.sandbox_sg.id]
  provisioner "remote-exec" {
    inline = ["sudo apt update -y", "sudo apt install apache2 -y", "sudo service apache2 start", "sudo mkdir -p /var/www/html", "echo '<html><body><h1>HeLLo </h1></body></html>' | sudo tee /var/www/html/index.html"]
  }

  connection {
    host        = aws_instance.instance.private_ip
    user        = var.login_user
    private_key = file("jaya.pem")
  }


}

resource "aws_security_group" "sandbox_sg" {
  name   = "sandbox security group"
  vpc_id = aws_vpc.test.id

  ingress {
    description = "inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "inbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc.my_ip]
  }

  egress {
    description = "outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    sg_name = "sandbox-security-group"
  }

}

resource "aws_vpc" "test" {
  cidr_block = var.vpc.cidr
  tags = {
    Name = "jayavpc"
  }
}


resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.test.id
  availability_zone       = "ap-south-1b"
  cidr_block              = var.vpc.cidr
  map_public_ip_on_launch = false
  tags = {
    Name = "privatesubnet"
  }
}

resource "aws_nat_gateway" "example" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.main.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.example.id
  }
  tags = {
    Name = "routejay"
  }
}

resource "aws_route_table_association" "association" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.private.id
}
