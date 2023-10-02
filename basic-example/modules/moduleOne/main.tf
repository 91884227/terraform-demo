resource "aws_instance" "server" {
  ami             = "ami-06e2b86bab2edf4ee" # Amazon linux
  instance_type   = "t2.micro"

  tags = {
    Name = var.module_one_var1
  }
}
