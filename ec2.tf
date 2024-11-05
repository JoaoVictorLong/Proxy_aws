# Variável com AMIs específicas para cada região
variable "amis_por_regiao" {
  type = map(string)
  default = {
    "us-east-1"      = "ami-01e3c4a339a264cc9"
    "us-east-2"      = "ami-04bb1b19f9e27b3c8"
    "us-west-1"      = "ami-04e74a9f5386208ab"
    "us-west-2"      = "ami-0c5aab85c243fa94f"
    "ap-south-1"     = "ami-08cfba77040c6f2a5"
    "ap-southeast-1" = "ami-0a8a03611fc5fbdac"
    "ap-southeast-2" = "ami-018655c45efb04bb7"
    "ap-northeast-3" = "ami-01ec4ece821f3df59"
    "ap-northeast-1" = "ami-05309f534862fbd29"
    "ap-northeast-2" = "ami-051d36838e83f6871"
    "ca-central-1"   = "ami-0b1afad4f1b642f89"
    "eu-central-1"   = "ami-00ac244ee0ad9050d"
    "eu-west-1"      = "ami-008d05461f83df5b1"
    "eu-west-2"      = "ami-0e1a523f05c744257"
    "eu-west-3"      = "ami-08eb3709ee2c1ccd6"
    "eu-north-1"     = "ami-052a4cae20b8ed212"
    "sa-east-1"      = "ami-0e7862da8cfc686ec"
  }
}

# Definindo o provedor AWS com alias para a região selecionada
provider "aws" {
  alias  = "selected_region"
  region = random_shuffle.aws_region.result[0]
}

# Diretório e caminho da chave local
locals {
  key_path_pem = "./key/proxy-server-key.pem"
  key_path = "./key/proxy-server-key"
  bash_bin = "./bash_bin/"
}

# Criando a chave SSH com nome único e importando-a na região selecionada
# Criando a chave SSH e importando-a na região selecionada
resource "null_resource" "create_key_pair" {
  provisioner "local-exec" {
    command = <<EOT
      # Gerar chave SSH (somente se ainda não existir)
      if [ ! -f "${local.key_path_pem}" ]; then
        mkdir -p ./key
        ssh-keygen -t rsa -b 2048 -f "${local.key_path}" -N ""
      fi

      # Registrar a chave pública na AWS na região selecionada
      aws ec2 import-key-pair --region ${random_shuffle.aws_region.result[0]} \
        --key-name "proxy-server-key" \
        --public-key-material fileb://${local.key_path}.pub
    EOT
  }
}

resource "null_resource" "delete_key_pair_aws" {
  provisioner "local-exec" {
    command = "./bash_bin/delete_keys_regions.sh"
    when = destroy
  } 
  triggers = {
    build_number = "${timestamp()}"
  }
}

resource "null_resource" "delete_key_pair" {
  provisioner "local-exec" {
    command = "rm -f ./key/*"
    when = destroy
  } 
  triggers = {
    build_number = "${timestamp()}"
  }
}

# Criação da instância EC2 usando o ID da AMI conforme a região selecionada
resource "aws_instance" "proxy1" {
  provider      = aws.selected_region
  ami           = var.amis_por_regiao[random_shuffle.aws_region.result[0]]
  instance_type = "t2.micro"
  key_name      = "proxy-server-key"

  vpc_security_group_ids = [
    aws_security_group.grupo_proxy.id,
  ]

  tags = {
    Name = "Proxy_server_1"
  }

  provisioner "local-exec" {
    command = <<EOT
    echo ssh -i ${local.key_path} ec2-user@${aws_instance.proxy1.public_ip} > ${local.bash_bin}/ssh.sh
    chmod 750 ${local.bash_bin}/*
    EOT
  }
}

output "public_ip" {
  value = aws_instance.proxy1.public_ip
}

output "selected_region" {
  value = random_shuffle.aws_region.result[0]
}
