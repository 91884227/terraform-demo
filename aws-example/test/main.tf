resource "aws_instance" "server" {
  count = 4

  ami             = "ami-06e2b86bab2edf4ee" # Amazon linux
  instance_type   = "t2.micro"

  tags = {
    Name = "Server ${count.index}"
  }
}
