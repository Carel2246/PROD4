import { Router } from "express";
import pool from "../config/db.js";

const router = Router();

// Get all tasks for a job
router.get("/by-job/:jobNumber", async (req, res) => {
  const { jobNumber } = req.params;
  try {
    const result = await pool.query(
      `SELECT * FROM task WHERE job_number = $1 ORDER BY task_number ASC`,
      [jobNumber]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch tasks" });
  }
});

// Get a single task by ID
router.get("/:taskId", async (req, res) => {
  const { taskId } = req.params;
  try {
    const result = await pool.query("SELECT * FROM task WHERE id = $1", [taskId]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Task not found" });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch task" });
  }
});

// Get all tasks
router.get("/", async (req, res) => {
  try {
    const result = await pool.query(`SELECT * FROM task ORDER BY id ASC`);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch tasks" });
  }
});

// Create new task
router.post("/", async (req, res) => {
  const {
    job_number,
    task_number,
    description,
    setup_time,
    time_each,
    predecessors,
    resources,
    completed,
    completed_at,
    busy,
  } = req.body;

  try {
    const result = await pool.query(
      `INSERT INTO task
        (job_number, task_number, description, setup_time, time_each, predecessors, resources, completed, completed_at, busy)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
       RETURNING *`,
      [
        job_number,
        task_number,
        description,
        setup_time,
        time_each,
        predecessors,
        resources,
        completed ?? false,
        completed_at,
        busy ?? false,
      ]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Failed to create task" });
  }
});

// Update task
router.patch("/:taskId", async (req, res) => {
  const { taskId } = req.params;
  const updates = req.body;

  const editableFields = [
    "job_number",
    "task_number",
    "description",
    "setup_time",
    "time_each",
    "predecessors",
    "resources",
    "completed",
    "completed_at",
    "busy",
  ];

  const fields = Object.keys(updates).filter((f) => editableFields.includes(f));
  if (fields.length === 0) return res.status(400).json({ error: "No valid fields" });

  const setClause = fields.map((f, i) => `${f} = $${i + 1}`).join(", ");
  const values = fields.map((f) => updates[f]);

  try {
    const result = await pool.query(
      `UPDATE task SET ${setClause} WHERE id = $${fields.length + 1} RETURNING *`,
      [...values, taskId]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Update failed" });
  }
});

// Delete task
router.delete("/:taskId", async (req, res) => {
  const { taskId } = req.params;
  try {
    await pool.query(`DELETE FROM task WHERE id = $1`, [taskId]);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: "Delete failed" });
  }
});

export default router;
