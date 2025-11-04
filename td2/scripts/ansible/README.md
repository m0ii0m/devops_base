# Installation & configuration
python3 -m venv .venv
source .venv/bin/activate
pip install ansible boto3 botocore

# Création & déploiement
ansible-playbook -v create_ec2_instance_playbook.yml
ansible-playbook -v -i inventory.aws_ec2.yml configure_sample_app_playbook.yml

# Arrêt & suppression
aws ec2 terminate-instances --instance-ids <Instance ID>
aws ec2 delete-key-pair --key-name ansible-ch2
aws ec2 delete-security-group --group-name sample-app-ansible
rm ~/.ssh/ansible-ch2.key