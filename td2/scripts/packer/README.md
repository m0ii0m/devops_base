# Installation & configuration
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install packer

# Création & déploiement
packer init sample-app.pkr.hcl
packer build sample-app.pkr.hcl

# Arrêt & suppression
aws ec2 deregister-image --image-id <AMI ID>