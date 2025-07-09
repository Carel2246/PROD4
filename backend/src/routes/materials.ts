import { Router } from "express";
import pool from "../config/db";

const router = Router();

router.get("/by-job/:jobNumber", async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT * FROM material WHERE job_number = $1 ORDER BY id ASC`,
      [req.params.jobNumber]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Material fetch failed" });
  }
});

router.post("/", async (req, res) => {
  const { job_number, name, quantity, unit, notes } = req.body;
  try {
    const result = await pool.query(
      `INSERT INTO material (job_number, name, quantity, unit, notes)
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [job_number, name, quantity, unit, notes]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Material insert failed" });
  }
});

router.patch("/:materialId", async (req, res) => {
  const fields = ["name", "quantity", "unit", "notes"];
  const keys = Object.keys(req.body).filter((k) => fields.includes(k));
  if (keys.length === 0) return res.status(400).json({ error: "No valid fields" });

  const setClause = keys.map((k, i) => `${k} = $${i + 1}`).join(", ");
  const values = keys.map((k) => req.body[k]);

  try {
    const result = await pool.query(
      `UPDATE material SET ${setClause} WHERE id = $${keys.length + 1} RETURNING *`,
      [...values, req.params.materialId]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Material update failed" });
  }
});

router.delete("/:materialId", async (req, res) => {
  try {
    await pool.query(`DELETE FROM material WHERE id = $1`, [req.params.materialId]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: "Delete failed" });
  }
});

export default router;
