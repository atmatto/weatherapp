#!/bin/bash

set -e

cd terraform
terraform apply

echo "Updating Ansible inventory"
mv -f ../ansible/inventory.yaml ../ansible/inventory.yaml.bkp
cat > ../ansible/inventory.yaml <<END
prod:
  hosts:
    server:
      ansible_host: $(terraform output -raw public_ip)
      ansible_user: maintainer
      ansible_ssh_private_key_file: ../id_ed25519
END

