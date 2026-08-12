const { Pool } = require('pg');
const config = require('../utils/config');
const pool = new Pool({ connectionString: config.DATABASE_URL, max: 20, idleTimeoutMillis: 30000, connectionTimeoutMillis: 5000 });
pool.on('error', (err) => { console.error('DB pool error:', err); process.exit(-1); });
async function query(text, params) { const start = Date.now(); const result = await pool.query(text, params); const duration = Date.now() - start; if (process.env.NODE_ENV === 'development') console.log('Query executed', { text: text.substring(0, 80), duration, rows: result.rowCount }); return result; }
async function getClient() { return await pool.connect(); }
module.exports = { query, getClient, pool };