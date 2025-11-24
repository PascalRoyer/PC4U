const express = require('express');
const { sql } = require('../db');
const router = express.Router();

//GET API pour les produits
router.get('/', async (req, res) => {
    try {
        const { q } = req.query;
        const request = new sql.Request();

        request.timeout = 60000;

        let where = '1 = 1';

        if (q) {
            request.input('q', sql.NVarChar, `%${q}%`);
            where += ' AND p.product_name LIKE @q';
        }
        const result = await request.query(`
            SELECT
                p.product_id,
                p.product_name,
                p.product_price,
                p.image_url,
                c.category_name
            FROM Products p
            LEFT JOIN Categories c ON p.category_id = c.category_id
            WHERE ${where}
            ORDER BY p.product_name;
        `);
        res.json(result.recordset);
    } catch (err) {
        console.error('GET /api/products error:', err);
        res.status(500).json({ error: 'Erreur serveur', detail: err.message });
    }
    
});
//GET API pour les produits et leurs spécifications
router.get('/:id', async (req, res) => {
    try {
        const id = parseInt(req.params.id, 10);
        if (Number.isNaN(id)) {
            return res.status(400).json({ error: 'ID invalide' });
    }

    // 1) Récupérer le produit + sa catégorie
    let request = new sql.Request();
    request.input('id', sql.Int, id);

    const prodResult = await request.query(`
        SELECT
            p.product_id,
            p.product_name,
            p.product_price,
            p.image_url,
            p.category_id,
            c.category_name
        FROM Products p
        JOIN Categories c ON p.category_id = c.category_id
        WHERE p.product_id = @id;
    `);

    if (prodResult.recordset.length === 0) {
        return res.status(404).json({ error: 'Produit introuvable' });
    }

    const product = prodResult.recordset[0];

    // 2) Récupérer les specs dans la bonne table
    let specs = null;
    const specReq = new sql.Request();
    specReq.input('pid', sql.Int, id);

    switch (product.category_name) {
        case 'CPU':
            specs = (await specReq.query(`
                SELECT * FROM CPU_Specs WHERE product_id = @pid
            `)).recordset[0] || null;
            break;

        case 'GPU':
            specs = (await specReq.query(`
                SELECT * FROM GPU_Specs WHERE product_id = @pid
            `)).recordset[0] || null;
            break;

        case 'Monitors':
            specs = (await specReq.query(`
                SELECT * FROM Monitor_Specs WHERE product_id = @pid
            `)).recordset[0] || null;
            break;

        case 'Memory_RAM':
            specs = (await specReq.query(`
                SELECT * FROM Memory_Specs WHERE product_id = @pid
            `)).recordset[0] || null;
            break;

        case 'Storage':
            specs = (await specReq.query(`
                SELECT * FROM Hard_Drive_Specs WHERE product_id = @pid
            `)).recordset[0] || null;
            break;

        case 'Power_supply':
            specs = (await specReq.query(`
                SELECT * FROM Power_supply_Specs WHERE product_id = @pid
            `)).recordset[0] || null;
            break;

        case 'Cases':
            specs = (await specReq.query(`
                SELECT * FROM Case_Specs WHERE product_id = @pid
            `)).recordset[0] || null;
            break;

        case 'Motherboards':
            specs = (await specReq.query(`
                SELECT * FROM Motherboard_Specs WHERE product_id = @pid
            `)).recordset[0] || null;
            break;
        default:
        specs = null;
    }

    return res.json({ product, specs });
} catch (err) {
    console.error('GET /api/products/:id error:', err);
    res.status(500).json({ error: 'Erreur serveur', detail: err.message });
}
});

module.exports = router;