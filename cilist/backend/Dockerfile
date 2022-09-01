FROM node:lts-gallium

WORKDIR /app

COPY . /app

COPY .env.example /app/.env

RUN apt update && apt install nano -y

RUN npm install

EXPOSE 5000

CMD [ "npm", "start" ]