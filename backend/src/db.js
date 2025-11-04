// backend/src/db.js
const sql = require('mssql');
require('dotenv').config();

const config = {
  server: process.env.DB_SERVER || process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE || process.env.DB_NAME,
  port: Number(process.env.DB_PORT || 1433),
  options: { encrypt: false, trustServerCertificate: true },
};

async function connectDB() {
  try {
    await sql.connect(config);
    console.log(' Connecté à SQL Server');
  } catch (err) {
    console.error(' Erreur SQL:', err.message);
  }
}

module.exports = { sql, connectDB };
