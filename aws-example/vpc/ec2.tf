resource "aws_instance" "BationHost" {
  ami                    = "ami-06e2b86bab2edf4ee" # Amazon linux
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.PublicSubnetA.id
  vpc_security_group_ids = [aws_security_group.instances.id]
  key_name = "key1002"
  tags = {
    Name = "BationHost"
  }
}

resource "aws_instance" "PrivateInstance" {
  ami                    = "ami-06e2b86bab2edf4ee" # Amazon linux
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.PrivateSubnetA.id
  vpc_security_group_ids = [aws_security_group.PrivateSG.id]
  key_name = "key1002"
  tags = {
    Name = "PrivateInstance"
  }
}

resource "aws_security_group" "instances" {
  name   = "instance-security-group"
  vpc_id = aws_vpc.demo.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_security_group" "PrivateSG" {
  name   = "PrivateSG"
  vpc_id = aws_vpc.demo.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [ aws_security_group.instances.id ]
  }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }  
}

# resource "aws_security_group_rule" "allow_bation_ssh_inbound" {
#   type              = "ingress"
#   security_group_id = aws_security_group.PrivateSG.id

#   from_port = 22
#   to_port   = 22
#   protocol  = "tcp"

#   source_security_group_id = aws_security_group.instances.id
# }
