# Weather App

## Backend

### Usage

`npm install` – install dependencies

`npm start` – run server

### Environment variables

- APPID – OpenWeatherMap API key
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
