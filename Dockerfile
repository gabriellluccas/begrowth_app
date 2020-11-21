FROM node:15.2.1
WORKDIR /usr/app
COPY package*.json ./
COPY yarn.lock ./
RUN yarn install
COPY . .
