FROM node:lts-gallium

ENV NODE_ENV=development

WORKDIR /app

COPY . /app

RUN npm install

RUN chmod +x wait-for-it.sh

EXPOSE 5000

CMD [ "npm", "start" ]