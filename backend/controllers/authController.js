const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const bcrypt = require('bcryptjs');
const { User } = require('../models');
const upload = require('../middleware/uploadMiddleware');
const nodemailer = require('nodemailer');
require('dotenv').config();

exports.verify2FA = async (req, res) => {
    try {
        const user = await User.findByPk(req.userId);

        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found.' });
        }

        if (!user.twoFactorToken || !user.twoFactorExpiry) {
            return res.status(400).json({ success: false, message: '2FA token not generated or expired.' });
        }

        const { code } = req.body;
        if (!code) {
            return res.status(400).json({ success: false, message: 'Verification code is required.' });
        }

        // Check if the token has expired
        if (user.twoFactorExpiry < Date.now()) {
            return res.status(400).json({ success: false, message: '2FA token has expired.' });
        }

        // Verify the token
        const hashedToken = crypto.createHash('sha256').update(code).digest('hex');
        if (hashedToken !== user.twoFactorToken) {
            return res.status(400).json({ success: false, message: 'Invalid 2FA token.' });
        }

        // Clear the token and expiry
        user.twoFactorToken = null;
        user.twoFactorExpiry = null;
        await user.save();

        res.status(200).json({ success: true, message: '2FA verified successfully.' });
    } catch (error) {
        console.error('Error verifying 2FA token:', error.message);
        res.status(500).json({ success: false, message: 'Failed to verify 2FA token.' });
    }
};

exports.enable2FA = async (req, res) => {
    try {
        const user = await User.findByPk(req.userId);

        if (!user) {
            return res.status(404).json({ error: 'User not found.' });
        }

        if (user.isTwoFactorEnabled) {
            return res.status(400).json({ error: 'Two-factor authentication is already enabled.' });
        }

        user.isTwoFactorEnabled = true;
        await user.save();

        res.status(200).json({
            message: 'Two-factor authentication enabled successfully.',
            user: { isTwoFactorEnabled: user.isTwoFactorEnabled },
        });
    } catch (error) {
        console.error('Error enabling 2FA:', error);
        res.status(500).json({ error: 'Failed to enable 2FA.' });
    }
};

exports.disable2FA = async (req, res) => {
    try {
        const user = await User.findByPk(req.userId);

        if (!user) {
            return res.status(404).json({ error: 'User not found.' });
        }

        if (!user.isTwoFactorEnabled) {
            return res.status(400).json({ error: 'Two-factor authentication is not enabled.' });
        }

        // Directly disable 2FA without verifying the token
        user.twoFactorSecret = null;
        user.isTwoFactorEnabled = false;
        await user.save();

        res.status(200).json({
            message: 'Two-factor authentication disabled successfully.',
            user: { id: user.id, isTwoFactorEnabled: user.isTwoFactorEnabled },
        });
    } catch (error) {
        console.error('Error disabling 2FA:', error);
        res.status(500).json({ error: 'Failed to disable 2FA.' });
    }
};

exports.sendEmail2FA = async (req, res) => {
    try {
        const user = await User.findByPk(req.userId);

        if (!user) {
            return res.status(404).json({ error: 'User not found.' });
        }

        const token2FA = crypto.randomInt(100000, 999999).toString();
        const hashedToken = crypto.createHash('sha256').update(token2FA).digest('hex');

        // Store the hashed token and expiry in the database (valid for 10 minutes)
        user.twoFactorToken = hashedToken;
        user.twoFactorExpiry = Date.now() + 10 * 60 * 1000; // 10 minutes
        await user.save();

        const transporter = nodemailer.createTransport({
            host: process.env.EMAIL_HOST,
            port: parseInt(process.env.EMAIL_PORT, 10),
            secure: process.env.EMAIL_SECURE === 'true',
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS,
            },
        });

        // Verify transporter
        await transporter.verify();

        // Send email
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: user.email,
            subject: 'Your 2FA Code',
            text: `Your verification code is: ${token2FA}`,
        };

        await transporter.sendMail(mailOptions);

        res.status(200).json({
            message: '2FA token sent to your email.',
            expiresIn: 10 * 60, // seconds
        });
    } catch (error) {
        console.error('Error sending 2FA email:', error);
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
    
    res.json({ token, is2FAEnabled: user.isTwoFactorEnabled });
};

exports.getUser = async (req, res) => {
    try {
        const user = await User.findByPk(req.userId, {
            attributes: ['id', 'name', 'email', 'image', 'isTwoFactorEnabled'],
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