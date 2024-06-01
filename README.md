# Weather App

## Development

Run the `dev.sh` script to start up the development environment. This hosts the frontend on port 8000 and exposes the API on port 9000. Hot reload is enabled.

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
