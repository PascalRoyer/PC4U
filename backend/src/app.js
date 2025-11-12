// backend/src/app.js
const express = require('express');
const cors = require('cors');
const path = require('path');
const prebuiltRoutes = require('./routes/prebuilt');

require('dotenv').config();

// Connexion SQL
const { connectDB } = require('./db');
// Routes
const authRoutes = require('./routes/auth');

//  Créer l'app AVANT d'utiliser app.use(...)
const app = express();

// Middlewares
app.use(cors());
app.use(express.json());

// DB
connectDB();

// Routes API
app.get('/api/health', (_, res) => {
  res.json({ ok: true, message: 'API + DB opérationnelles ' });
});
app.use('/api/auth', authRoutes);
app.use('/api/prebuilt', prebuiltRoutes);


// Frontend statique
const FRONTEND_DIR = path.join(__dirname, '../../frontend');
app.use(express.static(FRONTEND_DIR));
app.get('/', (_, res) => {
  res.sendFile(path.join(FRONTEND_DIR, 'index.html'));
});

// 404 JSON
app.use((req, res) => res.status(404).json({ error: 'Route introuvable ' }));

// Démarrage
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Serveur actif : http://localhost:${PORT}`);
});
