# syntax=docker/dockerfile:1
ARG NODE_VERSION=20-alpine

FROM node:${NODE_VERSION}
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

COPY package.json package-lock.json* ./
RUN npm ci --omit=dev

COPY src ./src

RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001 \
  && chown -R nodejs:nodejs /app
USER nodejs

EXPOSE 3000

CMD ["node", "src/index.js"]
