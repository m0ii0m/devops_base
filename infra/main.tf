terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Générer une clé SSH à la volée pour se connecter
resource "tls_private_key" "k8s_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "k3s-demo-key"
  public_key = tls_private_key.k8s_key.public_key_openssh
}

# 2. Sécurité : Ouvrir les ports (SSH, HTTP, K8s API)
resource "aws_security_group" "k8s_sg" {
  name        = "k3s-security-group"
  description = "Allow SSH, HTTP and K8s API"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubernetes API"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # NodePorts (Optionnel si on utilise NodePort au lieu de LB)
  ingress {
    description = "NodePorts"
    from_port   = 30000
    to_port     = 32767
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

# Récupérer l'AMI Ubuntu la plus récente (dynamique)
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# 3. Instance EC2 avec installation de K3s au démarrage
resource "aws_instance" "k3s_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name
  security_groups = [aws_security_group.k8s_sg.name]

  # Script de démarrage (UserData)
  user_data = <<-EOF
              #!/bin/bash
              # 1. Récupérer l'IP publique de l'instance (Métadonnées AWS)
              PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
              
              # 2. Installer K3s avec l'option --tls-san pour accepter cette IP
              curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --tls-san $PUBLIC_IP" sh -
              
              # Attendre que le fichier de config soit créé
              sleep 10
              
              # Autoriser l'utilisateur ubuntu à lire le kubeconfig
              chmod 644 /etc/rancher/k3s/k3s.yaml
              EOF

  tags = {
    Name = "K3s-Demo-Server"
  }
}

# 4. Sauvegarder la clé privée localement pour se connecter
resource "local_file" "ssh_key" {
  content  = tls_private_key.k8s_key.private_key_pem
  filename = pathexpand("~/.ssh/k3s-key.pem")
  file_permission = "0600"
}
