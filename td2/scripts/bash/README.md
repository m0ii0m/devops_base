# Installation & configuration
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws configure

# Création & déploiement
./deploy-ec2-instance.sh

# Arrêt & suppression
aws ec2 terminate-instances --instance-ids <Instance ID>
aws ec2 delete-security-group --group-id <Security Group ID>