// backend/src/routes/prebuilt.js
const router = require("express").Router();
const { sql } = require("../db");

/**
 * GET /api/prebuilt
 * Liste tous les templates (builds préconstruits)
 */
router.get("/", async (req, res) => {
  try {
    const result = await sql.query`
      SELECT template_id, template_name, total_price, created_at
      FROM Templates
      ORDER BY created_at DESC
    `;
    res.json(result.recordset);
  } catch (err) {
    console.error("Erreur GET /prebuilt :", err);
    res.status(500).json({
      error: "Impossible de charger les prebuilt",
      details: err.message,
    });
  }
});

/**
 * GET /api/prebuilt/:id
 * Détails d’un template + ses composants
 */
router.get("/:id", async (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    if (Number.isNaN(id)) {
      return res.status(400).json({ error: "ID de template invalide" });
    }

    const tpl = await sql.query`
      SELECT template_id, template_name, user_id_number, total_price, created_at
      FROM Templates
      WHERE template_id = ${id}
    `;

    if (tpl.recordset.length === 0) {
      return res.status(404).json({ error: "Template introuvable" });
    }

    const comps = await sql.query`
      SELECT component_id, template_id, component_name, selected_option, price
      FROM TemplateComponents
      WHERE template_id = ${id}
      ORDER BY component_id
    `;

    res.json({
      template: tpl.recordset[0],
      components: comps.recordset,
    });
  } catch (err) {
    console.error("Erreur GET /prebuilt/:id :", err);
    res.status(500).json({
      error: "Erreur lors du chargement du template",
      details: err.message,
    });
  }
});

/**
 * POST /api/prebuilt
 * Créer un template + tous ses composants
 * Body attendu :
 * {
 *   templateName: "Mon PC",
 *   user_id_number: 1,
 *   components: [
 *     { component_name: "cpu", selected_option: "AMD Ryzen 7 7700X", price: 349 },
 *     ...
 *   ]
 * }
 */
router.post("/", async (req, res) => {
  const { templateName, user_id_number, components } = req.body;

  if (!templateName || !Array.isArray(components) || components.length === 0) {
    return res.status(400).json({
      error: "templateName et components sont obligatoires",
    });
  }

  const totalPrice = components.reduce(
    (sum, c) => sum + Number(c.price || 0),
    0
  );

  const transaction = new sql.Transaction();

  try {
    await transaction.begin();

    // 1) Insert dans Templates
    const reqTpl = new sql.Request(transaction);
    const insertTplResult = await reqTpl
      .input("name", sql.NVarChar(255), templateName)
      .input("userId", sql.Int, user_id_number || null)
      .input("total", sql.Decimal(10, 2), totalPrice)
      .query(`
        INSERT INTO Templates (template_name, user_id_number, total_price, created_at)
        OUTPUT INSERTED.template_id
        VALUES (@name, @userId, @total, SYSDATETIME())
      `);

    const templateId = insertTplResult.recordset[0].template_id;

    // 2) Insert dans TemplateComponents
    for (const comp of components) {
      const reqComp = new sql.Request(transaction);
      await reqComp
        .input("tid", sql.Int, templateId)
        .input("cname", sql.NVarChar(100), comp.component_name)
        .input("sel", sql.NVarChar(255), comp.selected_option || "")
        .input("price", sql.Decimal(10, 2), comp.price || 0)
        .query(`
          INSERT INTO TemplateComponents (template_id, component_name, selected_option, price)
          VALUES (@tid, @cname, @sel, @price)
        `);
    }

    await transaction.commit();

    res.status(201).json({
      success: true,
      template_id: templateId,
    });
  } catch (err) {
    console.error("Erreur POST /prebuilt :", err);
    try {
      await transaction.rollback();
    } catch (rollbackErr) {
      console.error("Erreur rollback transaction /prebuilt :", rollbackErr);
    }
    res.status(500).json({
      error: "Erreur serveur lors de la création du template",
      details: err.message,
    });
  }
});

/**
 * DELETE /api/prebuilt/:id
 * Supprimer un template + ses composants
 */
router.delete("/:id", async (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    if (Number.isNaN(id)) {
      return res.status(400).json({ error: "ID de template invalide" });
    }

    // On supprime d'abord les composants pour éviter les erreurs de clé étrangère
    await sql.query`
      DELETE FROM TemplateComponents WHERE template_id = ${id};
      DELETE FROM Templates WHERE template_id = ${id};
    `;

    res.json({ success: true });
  } catch (err) {
    console.error("Erreur DELETE /prebuilt/:id :", err);
    res.status(500).json({
      error: "Erreur serveur lors de la suppression du template",
      details: err.message,
    });
  }
});

module.exports = router;
