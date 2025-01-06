const sequelize = require('../config/db'); // Database configuration
const User = require('./user'); // User model
const Transaction = require('./transaction'); // Transaction model

// Define associations
User.hasMany(Transaction, { foreignKey: 'userId', as: 'transactions' });
Transaction.belongsTo(User, { foreignKey: 'userId', as: 'user' });

// Sync database
sequelize.sync({ alter: true })
    .then(() => console.log('Database synced'))
    .catch(err => console.error('Error syncing database:', err));

// Export models and sequelize instance
module.exports = { sequelize, User, Transaction };
