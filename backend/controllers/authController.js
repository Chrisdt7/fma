const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const { User } = require('../models');
const upload = require('../middleware/uploadMiddleware');
const speakeasy = require('speakeasy');
const nodemailer = require('nodemailer');
require('dotenv').config();

exports.verifyTwoFactorAuth = async (req, res) => {
    const { token } = req.body;

    try {
        const user = await User.findByPk(req.userId);

        if (!user || !user.isTwoFactorEnabled) {
            return res.status(400).json({ error: 'Two-factor authentication is not enabled.' });
        }

        const isVerified = speakeasy.totp.verify({
            secret: user.twoFactorSecret,
            encoding: 'base32',
            token,
            window: 1,
        });

        if (!isVerified) {
            return res.status(401).json({ error: 'Invalid token.' });
        }

        res.json({ message: 'Token verified successfully.' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to verify 2FA token.' });
    }
};

exports.enableTwoFactorAuth = async (req, res) => {
    try {
        const user = await User.findByPk(req.userId);

        if (!user) {
            return res.status(404).json({ error: 'User not found.' });
        }

        // Generate a secret for the user
        const secret = speakeasy.generateSecret();
        user.twoFactorSecret = secret.base32;
        user.isTwoFactorEnabled = true;
        await user.save();

        res.json({
            message: 'Two-factor authentication enabled.',
            secret: secret.otpauth_url, // Use this to generate a QR code
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to enable 2FA.' });
    }
};

exports.disableTwoFactorAuth = async (req, res) => {
    try {
        const user = await User.findByPk(req.userId);

        if (!user) {
            return res.status(404).json({ error: 'User not found.' });
        }

        if (!user.isTwoFactorEnabled) {
            return res.status(400).json({ error: 'Two-factor authentication is not enabled.' });
        }

        // Verify 2FA token if necessary
        const { token } = req.body;
        if (token) {
            const isVerified = speakeasy.totp.verify({
                secret: user.twoFactorSecret,
                encoding: 'base32',
                token,
                window: 1, // Allow a small window for verification
            });

            if (!isVerified) {
                return res.status(401).json({ error: 'Invalid token.' });
            }
        }

        // Disable 2FA
        user.twoFactorSecret = null;
        user.isTwoFactorEnabled = false;
        await user.save();

        res.json({ message: 'Two-factor authentication disabled successfully.' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to disable 2FA.' });
    }
};

exports.sendEmail2FAToken = async (req, res) => {
    try {
        const user = await User.findByPk(req.userId);

        if (!user) {
            return res.status(404).json({ error: 'User not found.' });
        }

        // Generate a random 6-digit token
        const token = Math.floor(100000 + Math.random() * 900000).toString();

        // Store token and expiry in the database (valid for 10 minutes)
        user.twoFactorToken = token;
        user.twoFactorExpiry = Date.now() + 10 * 60 * 1000; // 10 minutes from now
        await user.save();

        // Send token via email
        const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS,
            },
        });

        await transporter.sendMail({
            from: process.env.EMAIL_USER,
            to: user.email,
            subject: 'Your 2FA Code',
            text: `Your verification code is: ${token}`,
        });

        res.json({ message: '2FA token sent to your email.' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to send 2FA token.' });
    }
};

exports.verifyEmail2FAToken = async (req, res) => {
    const { token } = req.body;

    try {
        const user = await User.findByPk(req.userId);

        if (!user) {
            return res.status(404).json({ error: 'User not found.' });
        }

        if (
            !user.twoFactorToken ||
            user.twoFactorToken !== token ||
            user.twoFactorExpiry < Date.now()
        ) {
            return res.status(401).json({ error: 'Invalid or expired token.' });
        }

        // Token is valid, clear it
        user.twoFactorToken = null;
        user.twoFactorExpiry = null;
        await user.save();

        res.json({ message: '2FA verification successful.' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to verify 2FA token.' });
    }
};

exports.register = async (req, res) => {
    try {
        const { name, email, password } = req.body;

        if (!name || !email || !password) {
            return res.status(400).json({ error: 'Name, email, and password are required.' });
        }

        // Check if the email is already registered
        const existingUser = await User.findOne({ where: { email } });
        if (existingUser) {
            return res.status(400).json({ error: 'Email is already in use.' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        // Handle image upload
        let image = 'default.img';
        if (req.file) {
            image = `/assets/profile/uploads/${req.file.filename}`; // Use full path for the frontend
        }

        const user = await User.create({ name, email, password: hashedPassword, image });

        res.status(201).json({
            id: user.id,
            name: user.name,
            email: user.email,
            image: user.image,
        });
    } catch (error) {
        console.error(error);

        // Handle Sequelize validation errors (e.g., unique constraint violations)
        if (error.name === 'SequelizeValidationError' || error.name === 'SequelizeUniqueConstraintError') {
            return res.status(400).json({ error: error.errors.map(err => err.message) });
        }

        res.status(500).json({ error: 'Internal server error.' });
    }
};


exports.login = async (req, res) => {
    const { email, password } = req.body;
    const user = await User.findOne({ where: { email } });

    if (!user || !await bcrypt.compare(password, user.password)) {
        return res.status(401).json({ error: 'Invalid credentials' });
    }

    const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET);
    res.json({ token });
};

exports.getUser = async (req, res) => {
    try {
        const user = await User.findByPk(req.userId, {
            attributes: ['id', 'name', 'email', 'image'],
        });

        // console.log('User:', user)

        if (!user) {
            return res.status(404).json({ error: 'User not found.' });
        }

        res.json(user);
    } catch (error) {
        res.status(500).json({ error: 'Internal server error.' });
    }
};

exports.updateUser = async (req, res) => {
    const { name, email, password } = req.body;

    try {
        // Find the user by ID
        const user = await User.findByPk(req.userId);
        console.log('Update User Request:', { name, email, password, file: req.file });

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        // Update user details
        if (name) user.name = name;
        if (email) user.email = email;
        if (password) user.password = await bcrypt.hash(password, 10); // Hash the password if it's being updated

        if (req.file) {
            const imagePath = `/assets/profile/uploads/${req.file.filename}`;
            
            // Optionally, delete the old image if it's not the default one
            if (user.image !== 'default.img') {
                const oldImagePath = `./public${user.image}`;
                const fs = require('fs');
                if (fs.existsSync(oldImagePath)) {
                    fs.unlinkSync(oldImagePath);
                }
            }
            
            user.image = imagePath;
        }

        // Save the updated user
        await user.save();

        // Respond with the updated user details (excluding sensitive fields like password)
        res.json({
            id: user.id,
            name: user.name,
            email: user.email,
            image: user.image,
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to update user details' });
    }
};

exports.changePassword = async (req, res) => {
    const { oldPassword, newPassword } = req.body;
    console.log('Request body:', req.body);

    try {
        // Fetch the user from the database
        const user = await User.findByPk(req.userId);

        if (!user) {
            return res.status(404).json({ error: 'User not found.' });
        }
        if (!oldPassword || !newPassword) {
            return res.status(400).json({ error: 'Old or new password is missing' });
        }

        // Verify the current password
        const isMatch = await bcrypt.compare(oldPassword, user.password);
        if (!isMatch) {
            return res.status(401).json({ error: 'Current password is incorrect.' });
        }

        // Hash the new password
        const hashedNewPassword = await bcrypt.hash(newPassword, 10);

        // Update the password in the database
        user.password = hashedNewPassword;
        await user.save();

        res.status(200).json({ success: true, message: 'Password changed successfully.' });
    } catch (error) {
        console.error('Error changing password:', error);
        res.status(500).json({ error: 'Internal server error.' });
    }
};