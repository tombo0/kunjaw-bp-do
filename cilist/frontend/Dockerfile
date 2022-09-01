FROM node:lts-gallium

ENV NODE_ENV=development

WORKDIR /app

COPY . /app

RUN apt update && apt install nano -y

RUN npm install

EXPOSE 3000

CMD [ "npm", "start" ]