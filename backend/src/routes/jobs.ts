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
