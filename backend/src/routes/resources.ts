import { Router } from "express";
import pool from "../config/db.js";

const router = Router();

router.get("/", async (req, res) => {
  try {
    const result = await pool.query("SELECT id, name, type FROM resource ORDER BY name ASC");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch resources" });
  }
});

// Add a resource
router.post("/", async (req, res) => {
  const { name, type } = req.body;
  try {
    const result = await pool.query(
      "INSERT INTO resource (name, type) VALUES ($1, $2) RETURNING *",
      [name, type]
    );
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: "Failed to add resource" });
  }
});

// Update a resource
router.put("/:id", async (req, res) => {
  const { id } = req.params;
  const { name, type } = req.body;
  try {
    const result = await pool.query(
      "UPDATE resource SET name = $1, type = $2 WHERE id = $3 RETURNING *",
      [name, type, id]
    );
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: "Failed to update resource" });
  }
});

// Delete a resource
router.delete("/:id", async (req, res) => {
  const { id } = req.params;
  try {
    await pool.query("DELETE FROM resource WHERE id = $1", [id]);
    res.sendStatus(204);
  } catch (err) {
    console.error("Failed to delete resource:", err);
    res.status(500).json({ error: "Failed to delete resource" });
  }
});

export default router;