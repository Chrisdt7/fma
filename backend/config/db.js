const { Sequelize } = require('sequelize');

// Create a Sequelize instance with the required dialect
const sequelize = new Sequelize('finance_app', 'ChrisDT', 'Since2K21', {
    host: 'localhost', // Replace with your database host if different
    dialect: 'postgres', // Specify the database dialect (e.g., 'mysql', 'sqlite', 'mariadb', 'postgres')
    logging: false, // Optional: Disable logging for a cleaner console output
});

module.exports = sequelize;
