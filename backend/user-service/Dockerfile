FROM node:18-alpine

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# env vars from your .env will be injected by Kubernetes via ConfigMaps/Secrets

EXPOSE $PORT
CMD ["npm", "start"]
