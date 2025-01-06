const Transaction = require('../models/transaction');
const jwt = require('jsonwebtoken');

// Fetch all transactions
exports.getTransactions = async (req, res) => {
    try {
        const transactions = await Transaction.findAll();
        res.status(200).json(transactions);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching transactions.' });
    }
};

// Add a new transaction
exports.addTransaction = async (req, res) => {
    const { amount, category, type, date } = req.body;
    const userId = req.userId;
  
    if (!amount || !category || !type || !date) {
      return res.status(400).json({ error: 'Missing required fields.' });
    }
  
    try {
      const transaction = await Transaction.create({
        amount, category, type, date, userId
      });
      res.status(201).json(transaction);
    } catch (error) {
      console.error('Error adding transaction:', error.message);
      res.status(400).json({ error: 'Error adding transaction.', details: error.message });
    }
  };
  
// Update a transaction
exports.updateTransaction = async (req, res) => {
    const { id } = req.params;
    const { amount, category, type, date } = req.body;

    try {
        const transaction = await Transaction.findByPk(id);

        if (!transaction) {
            return res.status(404).json({ error: 'Transaction not found.' });
        }

        transaction.amount = amount;
        transaction.category = category;
        transaction.type = type;
        transaction.date = date;

        await transaction.save();
        res.status(200).json(transaction);
    } catch (error) {
        res.status(400).json({ error: 'Error updating transaction.' });
    }
};

// Delete a transaction
exports.deleteTransaction = async (req, res) => {
    const { id } = req.params;

    try {
        const transaction = await Transaction.findByPk(id);

        if (!transaction) {
            return res.status(404).json({ error: 'Transaction not found.' });
        }

        await transaction.destroy();
        res.status(200).json({ message: 'Transaction deleted successfully.' });
    } catch (error) {
        res.status(500).json({ error: 'Error deleting transaction.' });
    }
};
