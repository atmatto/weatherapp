# Weather App

## Development

Run the `dev.sh` script to start up the development environment. This hosts the frontend on port 8000 and exposes the API on port 9000. Hot reload is enabled.

## Production

Static files are served using Nginx in a Docker container. API server is run in another Docker container. They are coordinated using Docker Compose and exposed to the Internet with a Caddy reverse proxy. Everything is managed using a Systemd service and will run automatically after a reboot.

### Server setup

A minimized installation of Ubuntu Server (e.g. version 24.04) with at least 15GB of disk space is recommended. OpenSSH needs to be installed.

An SSH key pair is needed for Ansible. You can generate it locally using `ssh-keygen -t ed25519` and upload to the server with `ssh-copy-id -i id_ed25519.pub username@server.ip.address` (with proper data inserted).

Update the data in `ansible/inventory.yaml` and check if everything works using `ansible prod -m ping -i inventory.yaml`.

The user used for Ansible must be allowed to use `sudo` without password. For example use `sudo visudo` and modify one of the lines to be: `%sudo ALL=(ALL:ALL) NOPASSWD:ALL`.

### Deployment

If needed, update the server IP address and other data in `ansible/inventory.yaml`. Ansible must be [installed](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) locally. Use the `deploy.sh` script to upload the latest commit on the `main` branch to the server, prepare everything and run the application.

## Backend

### Usage

`npm install` – install dependencies

`npm start` – run server

### Environment variables

- APPID_FILE – Path to a file containing the OpenWeatherMap API key (optional)
- APPID — OpenWeatherMap API key (this overrides the value from APPID_FILE)
- MAP_ENDPOINT – `http://api.openweathermap.org/data/2.5`
- TARGET_CITY – `Helsinki,fi`
- PORT – 9000

### API

`GET /api/weather`

## Frontend

### Usage

`NODE_OPTIONS=--openssl-legacy-provider npm start` – run Webpack in development mode

`NODE_OPTIONS=--openssl-legacy-provider npm run build` – build in production mode into `dist/`

### Environment variables

- HOST (devServer) – `0.0.0.0`
- PORT (devServer) – `8000`
- ENDPOINT – base URL, should end with `/api`, default: `http://0.0.0.0:9000/api`
