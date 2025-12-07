//backend/routes/cart.js
const express = require('express');
const { sql } = require('../db');
const authMiddleware = require('../middleware/auth.js');
const router = express.Router();

//POST api/cart
router.post('/', authMiddleware, async (req, res) => {
    try {
        const userId = req.user.id; //provient du token de JWT
        const { product_id, quantity } = req.body;

        if (!product_id) {
            return res.status(400).json({ error: 'product_id requis'});
        }

        const qty = Number(quantity) > 0 ? Number(quantity) : 1;
        let request = new sql.Request();
        request
            .input('uid', sql.BigInt, userId)
            .input('pid', sql.Int, product_id);
        
        const existing = await request.query(`
            SELECT cart_id, quantity
            FROM Cart
            WHERE user_id_number = @uid AND product_id = @pid;
        `);
        if (existing.recordset.length > 0) {
            //le produit est déjà existant dans le panier
            const currentQty = existing.recordset[0].quantity || 0;

            request = new sql.Request();
            await request
                .input('cid', sql.Int, existing.recordset[0].cart_id)
                .input('newQty', sql.Int, currentQty + qty)
                .query(`
                    UPDATE Cart
                    SET quantity = @newQty
                    WHERE cart_id = @cid
                `);
        } else {
            //produit inexistant dans le panier
            request = new sql.Request();
            await request
                .input('uid', sql.BigInt, userId)
                .input('pid', sql.Int, product_id)
                .input('qty', sql.Int, qty)
                .query(`
                    INSERT INTO Cart (user_id_number, product_id, quantity) VALUES
                    (@uid, @pid, @qty);
                `);
        }

        res.json({ success: true, message: 'Ajouté au panier'});
    } catch (err) {
        console.error('POST /api/cart error:', err);
        res.status(500).json({ error: 'Erreur serveur', detail: err.message });
    }
});

//GET api/cart
router.get('/', authMiddleware, async (req, res) => {
    try {
        const userId = req.user.id;
        const request = new sql.Request();
        request.input('uid', sql.BigInt, userId);
        const result = await request.query(`
            SELECT
                c.cart_id,
                c.product_id,
                c.quantity,
                p.product_name,
                p.product_price,
                p.image_url
            FROM Cart c
            JOIN Products p ON p.product_id = c.product_id
            WHERE c.user_id_number = @uid
        `);

        res.json(result.recordset);
    } catch (err) {
        console.error('GET /api/cart error', err);
        res.status(500).json({ error: 'Erreur serveur', detail: err.message})
    }
});

//DELETE api/cart/:cartId  (suppression d'une ligne de panier)
router.delete('/:cartId', authMiddleware, async (req, res) => {
    try {
        const userId = req.user.id;
        const cartId = parseInt(req.params.cartId, 10);
        if (Number.isNaN(cartId)) {
            return res.status(400).json({ error: 'cart id invalide' });
        }

        const request = new sql.Request();
        await request
            .input('cid', sql.BigInt, cartId)
            .input('uid', sql.BigInt, userId)
            .query(`
                DELETE FROM Cart
                WHERE cart_id = @cid AND user_id_number = @uid;
            `);
        res.json({ success: true });
    } catch (err) {
        console.error('DELETE /api/cart/:cartId error', err);
        res.status(500).json({ error: 'Erreur serveur', detail: err.message });
    }
});

//DELETE api/cart (Vider le panier)
router.delete('/', authMiddleware, async (req, res) => {
    try {
        const userId = req.user.id
        const request = new sql.Request();
        await request
            .input('uid', sql.BigInt, userId)
            .query(`
                DELETE FROM Cart
                WHERE user_id_number = @uid;
            `);
        res.json({ success: true });
    } catch (err) {
        console.error('DELETE /api/cart error', err);
        res.status(500).json({ error: 'Erreur serveur', detail: err.message });
    }
});
module.exports = router;
