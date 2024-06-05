#!/bin/bash

ssh-keygen -R [localhost]:2222 # The VM starts up with a random SSH fingerprint, forget previous one to avoid errors
ansible-playbook -i inventory.yaml ../ansible/playbook.yaml
