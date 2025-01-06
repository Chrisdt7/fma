const { Transaction } = require('../models');
const { Op, fn, col, literal } = require('sequelize');
const sequelize = require('../config/db');


exports.getReports = async (req, res) => {
    try {
        const income = await Transaction.sum('amount', {
            where: { type: 'income' },
        });
        const expense = await Transaction.sum('amount', {
            where: { type: 'expense' },
        });

        res.json({
            totalIncome: parseFloat(income) || 0.0,
            totalExpense: parseFloat(expense) || 0.0,
        });
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch reports' });
    }
};

// Fetch income report by date
// Fetch income report by date
exports.getIncomeReport = async (req, res) => {
    const { start, end } = req.query;
    const startDate = new Date(start);
    const endDate = new Date(end);
    endDate.setUTCHours(23, 59, 59, 999); // Ensure the end date is the full day

    console.log('Start Date:', startDate);
    console.log('End Date:', endDate);

    try {
        const totalIncome = await Transaction.sum('amount', {
            where: {
                type: 'income',
                date: {
                    [Op.between]: [startDate, endDate],
                },
            },
        });

        res.json({ totalIncome: parseFloat(totalIncome) || 0.0 });
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch income report' });
    }
};

// Fetch expense report by date
exports.getExpenseReport = async (req, res) => {
    const { start, end } = req.query;
    const startDate = new Date(start);
    const endDate = new Date(end);
    endDate.setUTCHours(23, 59, 59, 999); // Ensure the end date is the full day

    console.log('Start Date:', startDate);
    console.log('End Date:', endDate);

    try {
        const totalExpense = await Transaction.sum('amount', {
            where: {
                type: 'expense',
                date: {
                    [Op.between]: [startDate, endDate],
                },
            },
        });

        res.json({ totalExpense: parseFloat(totalExpense) || 0.0 });
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch expense report' });
    }
};


// Fetch chart data by date range
exports.getChartData = async (req, res) => {
    const { start, end } = req.query;

    const startDate = new Date(start);
    const endDate = new Date(end);
    endDate.setUTCHours(23, 59, 59, 999);
    console.log('Chart Query Start Date:', startDate);
    console.log('Chart Query End Date:', endDate);

    try {
        const chartData = await Transaction.findAll({
            attributes: [
                [sequelize.literal("DATE(date)"), 'date'], // PostgreSQL truncates time
                [fn('SUM', literal("CASE WHEN type = 'income' THEN amount ELSE 0 END")), 'income'],
                [fn('SUM', literal("CASE WHEN type = 'expense' THEN amount ELSE 0 END")), 'expense'],
            ],
            where: {
                date: {
                    [Op.between]: [startDate, endDate],
                },
            },
            group: [sequelize.literal("DATE(date)")], // Use DATE(date) for grouping
            order: [[sequelize.literal("DATE(date)"), 'ASC']],
        });

        if (!chartData || chartData.length === 0) {
            console.log('No transactions found in the specified range.');
            return res.json({ chartData: [] });
        }

        console.log('Raw Chart Data:', chartData);

        const formattedChartData = chartData.map(data => ({
            date: data.dataValues.date,
            income: parseFloat(data.dataValues.income) || 0.0,
            expense: parseFloat(data.dataValues.expense) || 0.0,
        }));

        console.log('Formatted Chart Data:', formattedChartData);
        res.json({ chartData: formattedChartData });
    } catch (error) {
        console.error('Error Fetching Chart Data:', error.message);
        res.status(500).json({ error: `Failed to fetch chart data: ${error.message}` });
    }
};