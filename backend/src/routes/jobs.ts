import { Router } from "express";
import pool from "../config/db";

const router = Router();

router.get("/incomplete", async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT job_number, description, promised_date, quantity, customer FROM job WHERE completed = false AND blocked = false ORDER BY promised_date ASC;"
    );
    res.json(result.rows);
  } catch (error) {
    console.error("Error fetching incomplete jobs:", error);
    res.status(500).json({ error: "Failed to fetch jobs" });
  }
});

export default router;

router.get("/dropdown", async (req, res) => {
  const includeCompleted = req.query.includeCompleted === "true";
  const includeBlocked = req.query.includeBlocked === "true";

  let query = `
    SELECT job_number, description
    FROM job
    WHERE 1=1
  `;

  if (!includeCompleted) query += " AND completed = false";
  if (!includeBlocked) query += " AND blocked = false";

  query += " ORDER BY promised_date ASC";

  try {
    const result = await pool.query(query);
    res.json(result.rows);
  } catch (err) {
    console.error("Dropdown fetch error:", err);
    res.status(500).json({ error: "Failed to fetch jobs" });
  }
});

router.patch("/:jobNumber", async (req, res) => {
  const jobNumber = req.params.jobNumber;
  const updates = req.body;

  // Whitelist fields
  const allowedFields = [
    "description", "order_date", "promised_date", "quantity",
    "price_each", "customer", "completed", "blocked", "job_number"
  ];

  const fields = Object.keys(updates).filter(field => allowedFields.includes(field));
  if (fields.length === 0) {
    return res.status(400).json({ error: "No valid fields to update" });
  }

  try {
    const setClause = fields.map((field, idx) => `${field} = $${idx + 1}`).join(", ");
    const values = fields.map((f) => updates[f]);

    const result = await pool.query(
      `UPDATE job SET ${setClause} WHERE job_number = $${fields.length + 1} RETURNING *`,
      [...values, jobNumber]
    );

    res.json(result.rows[0]);
  } catch (err) {
    console.error("Failed to update job:", err);
    res.status(500).json({ error: "Update failed" });
  }
});

router.get("/:jobNumber", async (req, res) => {
  const jobNumber = req.params.jobNumber;

  try {
    const result = await pool.query(
      `SELECT job_number, description, order_date, promised_date, quantity, price_each, customer, completed, blocked
       FROM job
       WHERE job_number = $1`,
      [jobNumber]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Job not found" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.error("Failed to fetch job:", err);
    res.status(500).json({ error: "Error fetching job" });
  }
});