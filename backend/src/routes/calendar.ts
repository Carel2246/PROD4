import { Router } from "express";
import pool from "../config/db.js";

const router = Router();

// Get all calendar entries
router.get("/", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM calendar ORDER BY weekday ASC");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch calendar" });
  }
});

// Update a calendar entry
router.put("/:id", async (req, res) => {
  const { id } = req.params;
  const { weekday, start_time, end_time } = req.body;
  try {
    const result = await pool.query(
      "UPDATE calendar SET weekday = $1, start_time = $2, end_time = $3 WHERE id = $4 RETURNING *",
      [weekday, start_time, end_time, id]
    );
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: "Failed to update calendar entry" });
  }
});

export default router;