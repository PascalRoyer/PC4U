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

//POST api/cart/checkout -> création de transaction
router.post('/checkout', authMiddleware, async (req, res) => {
    const userId = req.user.id;
    const pool = sql;

    const tx = new sql.Transaction();
    try {
        await tx.begin();
        //chargement du panier
        let request = new sql.Request(tx);
        request.input('uid', sql.BigInt, userId);
        const cartResult = await request.query(`
            SELECT
            c.cart_id,
            c.product_id,
            c.quantity,
            p.product_price
            FROM Cart c
            JOIN Products p ON p.product_id = c.product_id
            WHERE user_id_number = @uid;
            `);
        const items = cartResult.recordset;

        if (!items || items.length === 0) {
            await tx.rollback();
            return res.status(400).json({ error: 'Panier vide '});
        }

        //Calcul du total d'items et de prix
        let totalItems = 0;
        let totalCost = 0;

        items.forEach(it => {
            const qty = (Number(it.quantity || 0));
            const price = (Number(it.product_price || 0));
            totalItems += qty;
            totalCost += qty*price;
        });

        //Insertion dans la table Transactions et Transaction_details
        request = new sql.Request();
        request
            .input('uid', sql.BigInt, userId)
            .input('totalItems', sql.Int, totalItems)
            .input('totalCost', sql.Decimal(10, 2), totalCost);

        const transResult = await request.query(`
            INSERT INTO Transactions (transaction_date, total_items, total_cost, user_id_number)
            OUTPUT INSERTED.transaction_id
            VALUES (SYSUTCDATETIME(), @totalItems, @totalCost, @uid);
            `);

        const transactionId = transResult.recordset[0].transaction_id;

        //Insertion des détails
        for (const it of items) {
            const requestDet = new sql.Request(tx);
            await requestDet
                .input('tid', sql.BigInt, transactionId)
                .input('pid', sql.Int, it.product_id)
                .input('qty', sql.Int, it.quantity)
                .input('price', sql.Decimal(10, 2), it.product_price)
                .query(`
                    INSERT INTO Transaction_details (transaction_id, product_id, product_quantity, 
                    price_at_purchase)
                    VALUES (@tid, @pid, @qty, @price);
                    `)
        }

        //Vider la panier
        request = new sql.Request(tx);
        await request
            .input('uid', sql.BigInt, userId)
            .query(`
                DELETE FROM Cart WHERE user_id_number = @uid;
                `);
        
        //Commit transaction
        await tx.commit();
        
        return res.json({
            success: true,
            transaction_id: transactionId,
            total_items: totalItems,
            total_cost: totalCost
        });
    } catch (err) {
        console.error('POST /api/cart/checkout error:', err);
        try {
            await tx.rollback();
        } catch (rbErr) {
            console.error('Rollback error:', rbErr);
        }
        return res.status(500).json({ error: 'Erreur serveur', detail: err.message });
    }
});

module.exports = router;
