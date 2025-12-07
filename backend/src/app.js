// backend/src/app.js
const express = require('express');
const cors = require('cors');
const path = require('path');

require('dotenv').config();

// DB
const { connectDB } = require('./db');

// Routes
const authRoutes = require('./routes/auth');
const prebuiltRoutes = require('./routes/prebuilt');
const productsRoutes = require('./routes/products');
const cartRoutes = require('./routes/cart');

const app = express();

// Middlewares
app.use(
  cors({
    origin: 'http://localhost:8080', // ton frontend
    credentials: true,
  })
);
app.use(express.json());
app.use('/api/cart', cartRoutes);

// Connexion à la base SQL Server
connectDB();

// Routes API
app.get('/api/health', (_, res) => {
  res.json({ ok: true, message: 'API + DB opérationnelles' });
});

app.use('/api/auth', authRoutes);
app.use('/api/prebuilt', prebuiltRoutes);
app.use('/api/products', productsRoutes);
app.use('/api/cart', cartRoutes);

// Frontend statique
const FRONTEND_DIR = path.join(__dirname, '../../frontend');
app.use(express.static(FRONTEND_DIR));

app.get('/', (_, res) => {
  res.sendFile(path.join(FRONTEND_DIR, 'index.html'));
});

// 404 JSON pour les routes inconnues
app.use((req, res) => {
  res.status(404).json({ error: 'Route introuvable' });
});

// Démarrage du serveur
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`🚀 Serveur actif : http://localhost:${PORT}`);
});

module.exports = app;
