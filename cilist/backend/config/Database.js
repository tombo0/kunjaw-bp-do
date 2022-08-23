import {Sequelize} from "sequelize";

const db = new Sequelize('people','people','people',{
    host: 'database',
    dialect: 'mysql'
});

try {
    await db.authenticate();
    console.log('Connection has been established successfully.');
} catch (error) {
    console.error('Unable to connect to the database:', error);
}

export default db;