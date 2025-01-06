const express = require('express');
const { register, login, getUser, updateUser, changePassword, enableTwoFactorAuth, disableTwoFactorAuth, verifyTwoFactorAuth } = require('../controllers/authController');
const authMiddleware = require('../middleware/authMiddleware');
const upload = require('../middleware/uploadMiddleware');

const router = express.Router();

// Register and Login Routes
router.post('/register', upload.single('image'), register);
router.post('/login', login);

// User Routes
router.get('/user', authMiddleware, getUser);
router.put('/user', authMiddleware, upload.single('image'), updateUser);
router.post('/change-password', authMiddleware, changePassword);
router.post('/enable-2fa', authMiddleware, enableTwoFactorAuth);
router.post('/disable-2fa', authMiddleware, disableTwoFactorAuth);
router.post('/verify-2fa', authMiddleware, verifyTwoFactorAuth);

module.exports = router;
