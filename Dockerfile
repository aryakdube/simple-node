# syntax=docker/dockerfile:1
ARG NODE_VERSION=20-alpine

FROM node:${NODE_VERSION} AS base
WORKDIR /app

# Install dependencies
FROM base AS deps
COPY package.json package-lock.json* ./
RUN npm ci

# ---------------- MAIN ----------------
FROM base AS main
ENV APP_ENV=main
ENV NODE_ENV=development
ENV PORT=3000

COPY --from=deps /app/node_modules ./node_modules
COPY . .

EXPOSE ${PORT}

CMD ["sh", "-c", "npx babel-node src/index.js --presets es2015,stage-0"]

# ---------------- PROD ----------------
FROM base AS prod
ENV APP_ENV=production
ENV NODE_ENV=production
ENV PORT=4000

RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001

COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN chown -R nodejs:nodejs /app
USER nodejs

EXPOSE ${PORT}

CMD ["sh", "-c", "npx babel-node src/index.js --presets es2015,stage-0"]