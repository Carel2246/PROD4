import { Router } from "express";
import pool from "../config/db";

const router = Router();

// Get all holidays
router.get("/", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM holidays ORDER BY date ASC");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch holidays" });
  }
});

// Add a holiday
router.post("/", async (req, res) => {
  const { date, start_time, end_time, resources } = req.body;
  try {
    const result = await pool.query(
      "INSERT INTO holidays (date, start_time, end_time, resources) VALUES ($1, $2, $3, $4) RETURNING *",
      [date, start_time, end_time, resources]
    );
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: "Failed to add holiday" });
  }
});

// Update a holiday
router.put("/:id", async (req, res) => {
  const { id } = req.params;
  const { start_time, end_time, resources } = req.body;
  try {
    const result = await pool.query(
      "UPDATE holidays SET start_time = $1, end_time = $2, resources = $3 WHERE id = $4 RETURNING *",
      [start_time, end_time, resources, id]
    );
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: "Failed to update holiday" });
  }
});

// Delete a holiday
router.delete("/:id", async (req, res) => {
  const { id } = req.params;
  try {
    await pool.query("DELETE FROM holidays WHERE id = $1", [id]);
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: "Failed to delete holiday" });
  }
});

export default router;