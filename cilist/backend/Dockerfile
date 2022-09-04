FROM node:lts-gallium

WORKDIR /app

COPY . /app

RUN apt update && apt install nano -y

RUN npm install

EXPOSE 5000

CMD [ "npm", "start" ]