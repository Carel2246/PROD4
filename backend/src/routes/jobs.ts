import { Router } from "express";
import pool from "../config/db.js";

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

router.post("/", async (req, res) => {
  const { job_number } = req.body;
  try {
    const result = await pool.query(
      `INSERT INTO job (job_number, order_date, promised_date, quantity, price_each, completed, blocked)
       VALUES ($1, NOW(), NOW(), 1, 0, false, false)
       RETURNING *`,
      [job_number]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Failed to create job" });
  }
});

router.post("/duplicate", async (req, res) => {
  const { source_job_number, new_job_number } = req.body;
  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    // 1. Copy job details
    const jobRes = await client.query(
      `SELECT description, order_date, promised_date, quantity, price_each, customer
       FROM job WHERE job_number = $1`,
      [source_job_number]
    );
    if (jobRes.rows.length === 0) throw new Error("Source job not found");

    await client.query(
      `INSERT INTO job (job_number, description, order_date, promised_date, quantity, price_each, customer, completed, blocked)
       VALUES ($1, $2, $3, $4, $5, $6, $7, false, false)`,
      [
        new_job_number,
        jobRes.rows[0].description,
        jobRes.rows[0].order_date,
        jobRes.rows[0].promised_date,
        jobRes.rows[0].quantity,
        jobRes.rows[0].price_each,
        jobRes.rows[0].customer,
      ]
    );

    // 2. Copy tasks
    const tasksRes = await client.query(
      `SELECT * FROM task WHERE job_number = $1`,
      [source_job_number]
    );

    for (const t of tasksRes.rows) {
      // Update task_number and predecessors for new job
      const new_task_number = t.task_number.replace(source_job_number, new_job_number);

      // Update predecessors: replace all source_job_number-xx with new_job_number-xx
      let new_predecessors = t.predecessors;
      if (new_predecessors) {
        new_predecessors = new_predecessors
          .split(",")
          .map((p: string) => p.trim().replace(source_job_number, new_job_number))
          .filter((p: string) => p.length > 0)
          .join(",");
      }

      await client.query(
        `INSERT INTO task (job_number, task_number, description, setup_time, time_each, predecessors, resources, completed, completed_at)
         VALUES ($1, $2, $3, $4, $5, $6, $7, false, NULL)`,
        [
          new_job_number,
          new_task_number,
          t.description,
          t.setup_time,
          t.time_each,
          new_predecessors,
          t.resources,
        ]
      );
    }

    await client.query("COMMIT");
    res.json({ success: true });
  } catch (err) {
    await client.query("ROLLBACK");
    res.status(500).json({ error: "Failed to duplicate job" });
  } finally {
    client.release();
  }
});

router.get("/", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM job ORDER BY id ASC");
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch jobs" });
  }
});

export default router;