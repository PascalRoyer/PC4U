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

let pool = null;

// Connexion avec retry pour laisser le temps au conteneur SQL de démarrer
async function connectDB(retries = 10, delayMs = 5000) {
  try {
    pool = await sql.connect(config);
    console.log('✅ Connecté à SQL Server');
    return pool;
  } catch (err) {
    console.error('❌ Erreur SQL:', err.message);

    if (retries > 0) {
      console.log(
        `🔁 Nouvelle tentative dans ${delayMs / 1000}s... (reste ${retries - 1} essais)`
      );
      setTimeout(() => connectDB(retries - 1, delayMs), delayMs);
    } else {
      console.error('⛔ Impossible de se connecter à SQL Server après plusieurs essais.');
    }
  }
}

function getPool() {
  if (!pool) {
    throw new Error('Base de données non connectée ! Appelle connectDB() au démarrage.');
  }
  return pool;
}

module.exports = { sql, connectDB, getPool };
