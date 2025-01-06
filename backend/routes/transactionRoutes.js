const express = require('express');
const { addTransaction, getTransactions, updateTransaction, deleteTransaction } = require('../controllers/transactionController');
const authMiddleware = require('../middleware/authMiddleware');
const router = express.Router();

// Fetch all transactions
router.get('/', authMiddleware, getTransactions);

// Add a new transaction
router.post('/', authMiddleware, addTransaction);

// Update a transaction
router.put('/:id', authMiddleware, updateTransaction);

// Delete a transaction
router.delete('/:id', authMiddleware, deleteTransaction);

module.exports = router;
