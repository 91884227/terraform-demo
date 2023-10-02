# >>> type of variable
# string example
variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}

# list example
variable "user_information" {
  type = object({
    name     = string
    password = string
  })
  default = {
    name     = "chuck"
    password = "P@ssw0rd"
  }
}

# >>> property example
# sensitive example
variable "db_pass" {
  description = "Password for DB"
  type        = string
  sensitive   = true
}

variable "access_key" {
  
}

variable "secret_key" {
  
}