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

// Petite fonction avec retry pour laisser le temps au conteneur SQL de démarrer
async function connectDB(retries = 10, delayMs = 5000) {
  try {
    await sql.connect(config);
    console.log('✅ Connecté à SQL Server');
  } catch (err) {
    console.error('❌ Erreur SQL:', err.message);

    if (retries > 0) {
      console.log(`🔁 Nouvelle tentative dans ${delayMs / 1000}s... (reste ${retries - 1} essais)`);
      setTimeout(() => connectDB(retries - 1, delayMs), delayMs);
    } else {
      console.error('⛔ Impossible de se connecter à SQL Server après plusieurs essais.');
    }
  }
}

module.exports = { sql, connectDB };
