# Cilist
Simple CRUD app built with MySQL, ExpressJS, React, & Node.

`Database    : MySQL`

`Backend     : localhost:5000`

`Frontend    : localhost:3000`

# Setup

## Database
First you need to create database & user in MySQL in order to connect `Backend` to `Database`.

```
sudo mysql -u root -p
```

```
create database people;
```
```
create user people identified by 'people';
```
```
grant all privileges on people.* to people;
```
Then all you have to do now is restore database using this command
```
mysql -u people -p people < database/crud_db.sql
```

## Backend

Create .env file. Configure with appropriate value.

```
cd backend
```
```
cp .env.example .env
```

Simply install all dependencies then start the app.
```
npm install
```
And you can start with this command. You'll see the server is running on port `5000`
```
npm start
```

## Frontend

Create .env file. Configure with appropriate value.

```
cd frontend
```
```
cp .env.example .env
```

Because this is a React app, you can install all dependencies.
```
npm install
```
Then start the app. You'll see the app is running on port `3000`
```
npm start
```

# Credit

All credit goes to [M. Fikri](https://www.youtube.com/watch?v=es9_6RFR7wk&t=3336s) as creator of this app.

App used:

[Frontend](https://github.com/mfikricom/Frontend-React-MySQL)

[Backend](https://github.com/mfikricom/Backend-API-Express-MySQL)