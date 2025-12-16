
const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { sql } = require('../db');
const authMiddleware = require('../middleware/auth');
function uniquePseudo() {
    return "user_" + Math.random().toString(36).substring(2,10);
} /* permet générer un pseudo random si l'utilisateur n'en donne pas */

const router = express.Router();

/* -------------------- REGISTER -------------------- */

router.post('/register', async (req, res) => {
  try {
    const { email, user_password, user_pseudo } = req.body;

    if (!email || !user_password) {
      return res.status(400).json({ error: 'email et user_password requis' });
    }

    // vérifier si l'email existe
    let request = new sql.Request();
    const exists = await request
      .input('email', sql.NVarChar, email)
      .query('SELECT 1 AS ok FROM Users WHERE email = @email');

    if (exists.recordset.length > 0) {
      return res.status(409).json({ error: 'Email déjà utilisé' });
    }

    // génération du pseudo
    const userPseudo = (user_pseudo && user_pseudo.trim().length > 0) 
      ? user_pseudo.trim()
      : uniquePseudo();

    //  hash du mot de passe
    const hashed = await bcrypt.hash(user_password, 10);

    
    request = new sql.Request();
    await request
      .input('pseudo', sql.NVarChar, userPseudo)
      .input('email', sql.NVarChar, email)
      .input('pwd', sql.NVarChar, hashed)
      .query(`
        INSERT INTO Users (user_pseudo, email, user_password, user_type_id)
        VALUES (@pseudo, @email, @pwd, 3)
      `); /* 3 pour le user_type_id, sinon on crée des superadmin pour les clients */

    res.status(201).json({ success: true, message: 'Utilisateur créé ✅' });
  } catch (err) {
    console.error('Register error:', err);
    res.status(500).json({ error: 'Erreur serveur', detail: err.message });
  }
});

/* -------------------- LOGIN -------------------- */

router.post('/login', async (req, res) => {
  try {
    const { email, user_password } = req.body;

    if (!email || !user_password) {
      return res.status(400).json({ error: 'email et user_password requis' });
    }

    //  récupérer user par email
    let request = new sql.Request();
    const result = await request
      .input('email', sql.NVarChar, email)
      .query(`
        SELECT TOP 1 user_id_number, user_pseudo, email, user_password 
        FROM Users 
        WHERE email = @email
      `);

    if (result.recordset.length === 0) {
      return res.status(401).json({ error: 'Utilisateur introuvable' });
    }

    const user = result.recordset[0];

    //  comparer mot de passe hashé
    const ok = await bcrypt.compare(user_password, user.user_password);
    if (!ok) {
      return res.status(401).json({ error: 'Mot de passe incorrect' });
    }

    //  générer token JWT
    const token = jwt.sign(
      { id: user.user_id_number, pseudo: user.user_pseudo, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES || '2h' }
    );

    res.json({
      success: true,
      token,
      user: {
        id: user.user_id_number,
        pseudo: user.user_pseudo,
        email: user.email,
      }
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ error: 'Erreur serveur', detail: err.message });
  }
});
// GET /api/auth/me
// Nécessite un header Authorization: Bearer <token>
router.get('/me', authMiddleware, (req, res) => {
  // req.user vient du token décodé dans le middleware
  const { id, pseudo, email } = req.user;

  res.json({
    success: true,
    user: { id, pseudo, email },
  });
});

module.exports = router;
