# syntax=docker/dockerfile:1.4.0

ARG NODE_VERSION=22.2.0

FROM node:${NODE_VERSION}-alpine AS base
WORKDIR /usr/src/frontend
ENV NODE_OPTIONS=--openssl-legacy-provider

FROM base AS dev
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --include=dev
USER node
COPY . .
CMD npm run start

FROM base AS build
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev
USER node
COPY . .
CMD npm run build

FROM nginx AS prod
COPY --from=build /usr/src/frontend/dist /usr/share/nginx/html
EXPOSE 80
