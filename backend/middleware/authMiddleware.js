const jwt = require('jsonwebtoken');
require('dotenv').config();

module.exports = (req, res, next) => {
    const authHeader = req.header('Authorization');
    if (!authHeader) {
        return res.status(401).json({ error: 'Unauthorized: No token provided' });
    }

    const token = authHeader.split(' ')[1]; // Extract the token from "Bearer <token>"
    if (!token) {
        return res.status(401).json({ error: 'Unauthorized: Invalid token format' });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET); // Verify the token
        req.userId = decoded.userId; // Attach the user ID to the request
        next(); // Proceed to the next middleware or route handler
    } catch (err) {
        return res.status(403).json({ error: 'Forbidden: Invalid or expired token' });
    }
};
