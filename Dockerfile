# syntax=docker/dockerfile:1
FROM node:22-bookworm-slim AS base
RUN apt-get update \
 && apt-get install -y --no-install-recommends git curl ca-certificates ripgrep \
 && rm -rf /var/lib/apt/lists/* \
 && git config --system --add safe.directory '*'

# ---- dev: used for development (devcontainer / docker-compose.dev.yml)
FROM base AS dev
RUN npm install -g opencode-ai@1.19.5
WORKDIR /workspace
USER node
CMD ["sleep", "infinity"]

# ---- build
FROM base AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

# ---- runtime
FROM base AS runtime
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev && npm cache clean --force
COPY --from=build /app/dist ./dist
RUN mkdir -p /workspace && chown node:node /workspace
ENV PATH="/app/node_modules/.bin:${PATH}"
USER node
WORKDIR /workspace
ENTRYPOINT ["node", "/app/dist/index.js"]
