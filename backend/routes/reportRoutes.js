const express = require('express');
const { 
    getIncomeReport,
    getExpenseReport,
    getChartData
} = require('../controllers/reportController');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

// New Routes
router.get('/income', authMiddleware, getIncomeReport);
router.get('/expense', authMiddleware, getExpenseReport);
router.get('/chart-data', authMiddleware, getChartData);

module.exports = router;
