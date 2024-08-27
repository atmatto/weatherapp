# Weather App

## Development

Run the `dev.sh` script to start up the development environment. This hosts the frontend on port 8000 and exposes the API on port 9000. Hot reload is enabled.

Use the `./dev.sh build` command to force Docker to build the images. Remember to insert the OpenWeatherMap API key into the file `owm-appid.txt` for everything to be functional.

## Production

Static files are served using Nginx in a Docker container. API server is run in another Docker container. They are coordinated using Docker Compose and exposed to the Internet with a [Caddy](https://caddyserver.com/) reverse proxy. The UFW firewall is used for protection. Everything is managed using a Systemd service (`ansible/weatherapp.service`; it uses the `prod.sh` script to turn the app on and off) and will run automatically after a reboot.

## Deployment

The deployment has been tested on Ubuntu 24.04 Minimal. At least 5 GB of disk space is recommended.

Insert the OpenWeatherMap API key into the file `owm-appid.txt`.

Run `terraform init` in the `terraform/` directory.

Insert AWS API keys into the files named `terraform/aws_*_key` and run the `setup-server.sh` script. This will set up the required AWS infrastructure using terraform (`terraform/`). The file `ansible/inventory.yaml` will be automatically generated and the old one backed up.

To ensure proper configuration of HTTPS, add an `A` DNS record for your domain pointing to the newly created EC2 instance's public IP address. Then, update the domain name in `Caddyfile`. Caddy will automatically configure the required certificates.

The server is automatically configured using a [cloud-init](https://cloud-init.io/) file. The only thing that is left is running the script `deploy.sh` which runs the Ansible playbook. It uploads the latest commit on the `main` branch to the server, prepares everything and runs the application.

To manually inspect the server, connect to it using SSH to the account `maintainer`, using an appropriate private key.

### Test virtual machine

The `vm/` directory contains everything needed to simulate a real cloud server using QEMU/KVM. The directory contains an SSH key pair (`id_ed25519`) to be used only for testing purposes. The file `user-data` is identical to the file `terraform/cloud-init.yaml`, but contains the private key.

Run `./qemu.sh setup` to download the OS image and generate a disk image containing cloud-init files. Then, use `./qemu.sh run` command to turn on the VM. Use the `deploy.sh` script (from the `vm/` directory) to deploy the application to the VM using the real Ansible playbook. The application will be exposed on `localhost:2280` (forwarded from port 80 on the VM). Use the `connect.sh` script to inspect the VM with SSH.

## Backend

### Usage

`npm install` – install dependencies

`npm start` – run server

### Environment variables

- `APPID_FILE` – Path to a file containing the OpenWeatherMap API key (optional)
- `APPID` – OpenWeatherMap API key (this overrides the value from APPID_FILE)
- `MAP_ENDPOINT` – `http://api.openweathermap.org/data/2.5`
- `TARGET_CITY` – `Helsinki,fi`
- `PORT` – 9000

### API

`GET /api/weather`

## Frontend

### Usage

`NODE_OPTIONS=--openssl-legacy-provider npm start` – run Webpack in development mode

`NODE_OPTIONS=--openssl-legacy-provider npm run build` – build in production mode into `dist/`

### Environment variables

- `HOST` (devServer) – `0.0.0.0`
- `PORT` (devServer) – `8000`
- `ENDPOINT` – base URL, should end with `/api`, default: `http://0.0.0.0:9000/api`

## Possible improvements:

- Make a better Systemd service which would check the status of the application and restart it automatically in case of any issues.
- Enhance the monitoring and logging of the application.
