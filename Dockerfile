FROM node:20-bookworm-slim

WORKDIR /opt/app

# Dependencies required to build native modules (e.g. better-sqlite3)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

RUN corepack enable
RUN corepack prepare pnpm@8.15.8 --activate

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY . .

RUN pnpm build

ENV NODE_ENV=production
EXPOSE 1337

CMD ["pnpm", "start"]
