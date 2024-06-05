#!/bin/bash

chmod 0600 id_ed25519
ssh-keygen -R [localhost]:2222 # The VM starts up with a random SSH fingerprint, forget previous one to avoid errors
ssh -i id_ed25519 -p 2222 maintainer@localhost
