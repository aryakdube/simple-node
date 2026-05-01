# syntax=docker/dockerfile:1
ARG NODE_VERSION=20-alpine

FROM node:${NODE_VERSION} AS base
WORKDIR /app

ENV NODE_ENV=production

COPY package.json package-lock.json* ./
RUN npm ci --omit=dev

COPY src ./src

RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001 \
  && chown -R nodejs:nodejs /app
USER nodejs

# prod: app listens on 4000
FROM base AS prod
ENV PORT=4000
EXPOSE 4000
CMD ["node", "src/index.js"]

# main: app listens on 3000 (default image when no --target)
FROM base AS main
ENV PORT=3000
EXPOSE 3000
CMD ["node", "src/index.js"]
