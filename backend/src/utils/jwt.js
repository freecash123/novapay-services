const jwt = require('jsonwebtoken');
const config = require('./config');
function generateTokens(user) { const payload = { id: user.id, email: user.email, role: user.role }; const accessToken = jwt.sign(payload, config.JWT_SECRET, { expiresIn: config.JWT_EXPIRES_IN }); const refreshToken = jwt.sign(payload, config.JWT_REFRESH_SECRET, { expiresIn: config.JWT_REFRESH_EXPIRES_IN }); return { accessToken, refreshToken }; }
function verifyAccessToken(token) { return jwt.verify(token, config.JWT_SECRET); }
function verifyRefreshToken(token) { return jwt.verify(token, config.JWT_REFRESH_SECRET); }
module.exports = { generateTokens, verifyAccessToken, verifyRefreshToken };