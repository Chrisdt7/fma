const express = require('express');
const authRoutes = require('./routes/authRoutes');
const transactionRoutes = require('./routes/transactionRoutes');
const reportRoutes = require('./routes/reportRoutes');
const sequelize = require('./config/db');
require('dotenv').config();

const app = express();
app.use(express.json());

app.use('/auth', authRoutes);
app.use('/transactions', transactionRoutes);
app.use('/reports', reportRoutes);

const startServer = async () => {
    try {
        await sequelize.authenticate(); // Test the database connection
        console.log('Database connected successfully.');

        await sequelize.sync(); // Synchronize models with the database
        console.log('Database synchronized.');

        app.listen(process.env.PORT, () => {
            console.log(`Server running on port ${process.env.PORT}`);
        });
    } catch (error) {
        console.error('Error starting server:', error);
        process.exit(1); // Exit if there's an error
    }
};

startServer();
