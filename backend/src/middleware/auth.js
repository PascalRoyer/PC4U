const jwt = require('jsonwebtoken');

module.exports = function (req, res, next) {
    const authHeader = req.headers.authorization


    if (!authHeader) {
        return res.status(401).json({ error: 'Token manquant'});
    }
    const parts = authHeader.split(' ');
    if (parts.length !== 2 || parts[0] !== 'Bearer') {
        return res.status(401).json({ error: 'Format de token invalide' });
    }

    const token = parts[1];

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        // On stocke les infos utilisateur dans req.user
        req.user = decoded;
        next(); // on laisse passer vers la route protégée
    } catch (err) {
        return res.status(401).json({ error: 'Token invalide ou expiré' });
    }
};
