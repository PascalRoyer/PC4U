// URL du site / API
// - En dev local: backend sur http://localhost:8080
// - En prod / ngrok: on utilise l'origine de la page (https://xxxxx.ngrok-free.app)
const API_BASE = (function () {
    const origin = window.location.origin;

  // Si on est sur une URL ngrok (présentation)
    if (origin.includes('ngrok-free.app')) {
        return origin;            // ex: https://pc4u-demo.ngrok-free.app
    }

  // Si on sert tout via Express sur 8080 (http://localhost:8080/...)
    if (origin.includes('localhost:8080') || origin.includes('127.0.0.1:8080')) {
        return origin;
    }

  // Sinon, fallback dev classique: backend sur 8080
    return 'http://localhost:8080';
})();


//Helpers token et user
function saveAuth(token, user) {
    localStorage.setItem('pc4u_token', token);
    localStorage.setItem('pc4u_user', JSON.stringify(user));
}

function getToken() {
    return localStorage.getItem('pc4u_token');
}

function getCurrentUser() {
    const raw = localStorage.getItem('pc4u_user');
    if (!raw) return null;
    try {
        return JSON.parse(raw);
    } catch {
        return null;
    }
}

function clearAuth() {
    localStorage.removeItem('pc4u_token');
    localStorage.removeItem('pc4u_user');
}

//Protection des pages//

async function requireAuth() {
    const token = getToken();
    if (!token) {
        // Pas connecté → on renvoie vers login
        window.location.href = 'login.html';
        return;
    }

  // Optionnel : vérifier auprès du backend que le token est encore valide
    try {
        const res = await fetch(`${API_BASE}/api/auth/me`, {
        headers: {
            'Authorization': `Bearer ${token}`
        }
        });

        if (!res.ok) {
        // Token invalide / expiré
        clearAuth();
        window.location.href = 'login.html';
        return;
        }

        const data = await res.json();
        // On met à jour le user stocké
        saveAuth(token, data.user);
    } catch (err) {
        console.error('Erreur /me:', err);
        // En cas de gros souci réseau, tu peux décider soit de rester, soit de renvoyer au login
    }
}

// --- Logout global --- //
function logout() {
    clearAuth();
    window.location.href = 'login.html';
}

// On expose les fonctions dans window pour les appeler depuis d'autres scripts / HTML
window.PC4UAuth = {
    saveAuth,
    getToken,
    getCurrentUser,
    requireAuth,
    logout,
    API_BASE
};
