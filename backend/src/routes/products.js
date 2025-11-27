const express = require('express');
const { sql } = require('../db');
const router = express.Router();

//GET API pour les produits
router.get('/', async (req, res) => {
    try {
        const { q } = req.query;
        const request = new sql.Request();

        request.requestTimeout = 60000;

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

//GET API pour les filtres
router.get('/filter', async (req, res) => {
    const {
        category,
        minPrice,
        maxPrice,
        //Filtres pour CPU
        corecount,
        coreclock,
        boostclock,
        microarchitecture,
        tdp,
        graphics,
        //Filtres pour GPU
        memory,
        mcoreclock,
        mboostclock,
        length,
        //Filtres pour moniteurs
        screensize,
        resolution,
        refreshrate,
        responsetime,
        paneltype,
        aspectratio,
        //Filtres pour ram
        speed,
        modules,
        firstwordlat,
        caslat,
        //Filtres pour hard drives
        hddtype,
        interface,
        capacity,
        //Filtres pour alimentation
        pstype,
        efficiency,
        wattage,
        modular,
        //Filtres pour boîtiers
        casetype,
        sidepanel,
        externalvol,
        internal35bays,
        //Filtres pour cartes-mère
        socket,
        formfactor,
        maxmemory,
        memoryslots
    } = req.query

    try {
        const request = new sql.Request();
        request.timeout = 60000;

        let joins = 'LEFT JOIN Categories c ON p.category_id = c.category_id';
        let where = '1 = 1';
        //Filtre pour les catégories
        if (category) {
            where += ' AND c.category_name = @category';
            request.input('category', sql.NVarChar, category);
            }
        //Filtres généraux
        if (minPrice) {
            where += ' AND p.product_price >= @minPrice';
            request.input('minPrice', sql.Decimal(10, 2), minPrice);
            }

        if (maxPrice) {
            where += ' AND p.product_price <= @maxPrice';
            request.input('maxPrice', sql.Decimal(10, 2), maxPrice);
            }

        //Filtres spécifiques
        //Filtre CPU
        let hasCPU = false;
        
        if (corecount) {
            hasCPU = true;
            where += ' AND cs.core_count = @corecount';
            request.input('corecount', sql.Int, corecount);
        }
        if (coreclock) {
            hasCPU = true;
            where +=' AND cs.core_clock_ghz = @coreclock';
            request.input('coreclock', sql.Decimal(6, 3), coreclock);
        }
        if (boostclock) {
            hasCPU = true;
            where +=' AND cs.boost_clock_ghz = @boostclock';
            request.input('corecount', sql.Decimal(6, 3), boostclock);
        }
        if (microarchitecture) {
            hasCPU = true;
            where +=' AND cs.microarchitecture = @microarchitecture';
            request.input('microarchitecture', sql.NVarChar, microarchitecture);
        }
        if (tdp) {
            hasCPU = true;
            where +=' AND cs.tdp_watts = @tdp';
            request.input('tdp', sql.Decimal, tdp);
        }
        if (graphics) {
            hasCPU = true;
            where +=' AND cs.graphics = @graphics';
            request.input('graphics', sql.NVarChar, graphics);
        }
        if (hasCPU) {
            joins += ' JOIN CPU_Specs cs ON p.product_id = cs.product_id';
        }

        //Filtre GPU
        let hasGPU = false;

        if (memory) {
            hasGPU = true;
            where += ' AND gs.memory = @memory';
            request.input('memory', sql.Int, memory);
        }
        if (mcoreclock) {
            hasGPU = true;
            where +=' AND gs.core_clock = @mcoreclock';
            request.input('mcoreclock', sql.Int, mcoreclock);
        }
        if (mboostclock) {
            hasGPU = true;
            where += ' AND gs.boost_clock = @mboostclock';
            request.input('mboostclock', sql.Int, mboostclock);
        }
        if (length) {
            hasGPU = true;
            where += ' AND gs.length = @length';
            request.input('length', sql.Int, length);
        }
        if (hasGPU) {
            joins += ' JOIN GPU_Specs gs ON p.product_id = gs.product_id';
        }

        //Filtre moniteurs
        let hasMon = false

        if (screensize) {
            hasMon = true;
            where += ' AND ms.screen_size = @screensize';
            request.input('screensize', sql.Int, screensize);
        }
        if (resolution) {
            hasMon = true;
            where += ' AND ms.resolution = @resolution';
            request.input('resolution', sql.NVarChar, resolution);
        }
        if (refreshrate) {
            hasMon = true;
            where += 'AND ms.refresh_rate = @refreshrate';
            request.input('refreshrate', sql.Int, refreshrate);
        }
        if (responsetime) {
            hasMon = true;
            where += ' AND ms.response_time = @responsetime';
            request.input('responsetime', sql.Decimal(5, 2), responsetime);
        }
        if (paneltype) {
            hasMon = true;
            where += ' AND ms.panel_type = @paneltype';
            request.input('paneltype', sql.NVarChar, paneltype);
        }
        if (aspectratio) {
            hasMon = true;
            where += ' AND ms.aspect_ratio = @aspectratio';
            request.input('aspectratio', sql.Int, aspectratio);
        }
        if (hasMon) {
            joins += ' JOIN Monitor_Specs ms ON p.product_id = ms.product_id';
        }

        //Filtre Memory/RAM
        let hasMRAM = false;

        if (speed) {
            hasMRAM = true;
            where +=' AND mr.speed = @speed';
            request.input('speed', sql.Int, speed);
        }
        if (modules) {
            hasMRAM = true;
            where +=' AND mr.modules = @modules';
            request.input('modules', sql.NVarChar, modules);
        }
        if (firstwordlat) {
            hasMRAM = true;
            where +=' AND mr.first_word_latency = @firstwordlat';
            request.input('firstwordlat', sql.Int, firstwordlat);
        }
        if (caslat) {
            hasMRAM = true;
            where += ' AND mr.cas_latency = @caslat';
            request.input('caslat', sql.Int, caslat);
        }
        if (hasMRAM) {
            joins += ' JOIN Memory_Specs mr ON p.product_id = mr.product_id';
        }

        //Filtre Hard drives
        let hasHDD = false;

        if (hddtype) {
            hasHDD = true;
            where += ' AND hs.type = @hddtype';
            request.input('hddtype', sql.NVarChar, hddtype);
        }
        if (interface) {
            hasHDD = true;
            where += ' AND hs.interface = @interface';
            request.input('interface', sql.NVarChar, interface);
        }
        if (capacity) {
            hasHDD = true;
            where += 'AND hs.capacity = @capacity';
            request.input('capacity', sql.Int, capacity);
        }
        if (hasHDD){
            joins += ' JOIN Hard_Drive_Specs hs ON p.product_id = hs.product_id';
        }

        //Filtre alimentations
        let hasPS = false;

        if (pstype) {
            hasPS = true;
            where += ' AND ps.type = @pstype';
            request.input('pstype', sql.NVarChar, pstype);
        }
        if (efficiency) {
            hasPS = true;
            where += ' AND ps.efficiency = @efficiency';
            request.input('efficiency', sql.NVarChar, efficiency);
        }
        if (wattage) {
            hasPS = true;
            where += ' AND ps.wattage = @wattage';
            request.input('wattage', sql.Int, wattage);
        }
        if (modular) {
            hasPS = true;
            where += ' AND ps.modular = @modular';
            request.input('modular', sql.NVarChar, modular);
        }
        if (hasPS) {
            joins += ' JOIN Power_supply_Specs ps ON p.product_id = ps.product_id';
        }

        //Filtre boîtiers
        let hasCase = false;

        if (casetype) {
            hasCase = true;
            where += ' AND ca.type = @type';
            request.input('casetype', sql.NVarChar, casetype);
        }
        if (sidepanel) {
            hasCase = true;
            where += ' AND ca.side_panel = @sidepanel';
            request.input('sidepanel', sql.NVarChar, sidepanel);
        }
        if (externalvol) {
            hasCase = true;
            where += ' AND ca.external_volume = @externalvol';
            request.input('externalvol', sql.Decimal(4, 2), externalvol);
        }
        if (internal35bays) {
            hasCase = true;
            where += ' AND ca.internal_35_bays = @internal35bays';
            request.input('internal35bays', sql.Int, internal35bays);
        }
        if (hasCase) {
            joins += ' JOIN Case_Specs ca ON p.product_id = ca.product_id';
        }

        //Filtre carte-mère
        let hasMB = false;

        if (socket) {
            hasMB = true;
            where += ' AND mb.socket = @socket';
            request.input('socket', sql.NVarChar, casetype);
        }
        if (formfactor) {
            hasMB = true;
            where += ' AND mb.form_factor = @formfactor';
            request.input('formfactor', sql.NVarChar, formfactor);
        }
        if (maxmemory) {
            hasMB = true;
            where += ' AND mb.max_memory = @maxmemory';
            request.input('maxmemory', sql.Int, maxmemory);
        }
        if (memoryslots) {
            hasMB = true;
            where += ' AND mb.memory_slots = @memoryslots';
            request.input('memoryslots', sql.NVarChar, memoryslots);
        }
        if (hasMB) {
            joins += ' JOIN Motherboard_Specs mb ON p.product_id = mb.product_id';
        }

        //query final
        const query = `
            SELECT p.*, c.category_name
            FROM Products p
            ${joins}
            WHERE ${where}
            ORDER BY p.product_name;
        `;

        const result = await request.query(query);
        res.json(result.recordset);
    } catch (err){
        console.error("GET /api/products/filter error:", err);
        res.status(500).json({ error: "Erreur serveur", detail: err.message });
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