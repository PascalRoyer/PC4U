// backend/src/routes/prebuilt.js
const router = require("express").Router();
const { getPool, sql } = require("../db");

/** ✅ Route GET /api/prebuilt
 *  Liste tous les templates (builds préconstruits)
 */
router.get("/", async (req, res) => {
  try {
    const pool = getPool();
    const result = await pool.request().query(`
      SELECT t.template_id, t.template_name, t.total_price, t.created_at
      FROM Templates t
      ORDER BY t.created_at DESC
    `);
    res.json(result.recordset);
  } catch (err) {
    console.error("Erreur GET /prebuilt :", err.message);
    res.status(500).json({ error: "Impossible de charger les prebuilt" });
  }
});

/** ✅ Route GET /api/prebuilt/:id
 *  Détails d’un template + ses composants
 */
router.get("/:id", async (req, res) => {
  try {
    const pool = getPool();
    const id = Number(req.params.id);

    const t = await pool.request()
      .input("id", sql.Int, id)
      .query(`
        SELECT template_id, template_name, user_id_number, total_price, created_at
        FROM Templates
        WHERE template_id = @id
      `);

    if (t.recordset.length === 0) {
      return res.status(404).json({ error: "Template introuvable" });
    }

    const c = await pool.request()
      .input("id", sql.Int, id)
      .query(`
        SELECT component_id, component_name, selected_option, price
        FROM TemplateComponents
        WHERE template_id = @id
        ORDER BY component_id
      `);

    res.json({
      template: t.recordset[0],
      components: c.recordset
    });
  } catch (err) {
    console.error("Erreur GET /prebuilt/:id :", err.message);
    res.status(500).json({ error: "Erreur lors du chargement du template" });
  }
});

module.exports = router;
