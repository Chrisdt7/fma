const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const User = sequelize.define('User', {
    name: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
    },
    password: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    image: {
        type: DataTypes.STRING,
        allowNull: false,
        defaultValue: 'default.png',
    },
    twoFactorSecret: {
        type: DataTypes.STRING,
        allowNull: true,
    },
    twoFactorToken: {
        type: DataTypes.STRING,
        allowNull: true,
    },
    twoFactorExpiry: {
        type: DataTypes.DATE,
        allowNull: true,
    },
    isTwoFactorEnabled: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
    },
});

module.exports = User;
