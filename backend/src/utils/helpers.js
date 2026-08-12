const crypto = require('crypto');
function generateOrderNumber() { const d = new Date(); const y = d.getFullYear(); const m = String(d.getMonth() + 1).padStart(2, '0'); const day = String(d.getDate()).padStart(2, '0'); const rand = crypto.randomBytes(2).toString('hex').toUpperCase(); return `NP-${y}${m}${day}-${rand}`; }
module.exports = { generateOrderNumber };