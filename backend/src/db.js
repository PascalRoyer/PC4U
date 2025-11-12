// backend/src/db.js
const sql = require('mssql');
require('dotenv').config();

// Configuration SQL Server
const config = {
  server: process.env.DB_SERVER || process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE || process.env.DB_NAME,
  port: Number(process.env.DB_PORT || 1433),
  options: { encrypt: false, trustServerCertificate: true },
};

let pool;

/** Connexion principale à la base de données */
async function connectDB() {
  try {
    if (pool) return pool; // évite les reconnexions multiples
    pool = await sql.connect(config);
    console.log(' Connecté à SQL Server');
    return pool;
  } catch (err) {
    console.error(' Erreur SQL:', err.message);
  }
}

/** Récupérer la connexion existante */
function getPool() {
  if (!pool) throw new Error('❌ Base de données non connectée. Appelle connectDB() avant.');
  return pool;
}

module.exports = { sql, connectDB, getPool };
