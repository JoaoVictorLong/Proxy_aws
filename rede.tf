variable "port_range" {
  type    = map(number)
  default = {
    min = 10000
    max = 65000
  }
}

resource "random_integer" "find_port" {
  min = var.port_range["min"]
  max = var.port_range["max"]
  #count = 1
}

resource "aws_security_group" "grupo_proxy" {
  provider = aws.selected_region
  name_prefix = "proxy_group_security"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = random_integer.find_port.result
    to_port     = random_integer.find_port.result
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

output "random_port" {
  value = random_integer.find_port.result
  description = "The randomly selected open port for this security group"
}