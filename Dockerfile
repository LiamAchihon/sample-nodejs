FROM node:22-alpine AS dependencies

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev && npm cache clean --force


FROM node:22-alpine AS runtime

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=8080

COPY --from=dependencies /app/node_modules ./node_modules
COPY app.js ./app.js
COPY package*.json ./

EXPOSE 8080

USER node

CMD ["node", "app.js"]
