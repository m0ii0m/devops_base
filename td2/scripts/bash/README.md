./deploy-ec2-instance.sh

aws ec2 terminate-instances --instance-ids <Instance ID>
aws ec2 delete-security-group --group-id <Security Group ID>