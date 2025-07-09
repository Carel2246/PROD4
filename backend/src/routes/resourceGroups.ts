import { Router } from "express";
import pool from "../config/db";

const router = Router();

// Get all groups with their resources
router.get("/", async (req, res) => {
  try {
    const groupsResult = await pool.query("SELECT id, name, type FROM resource_group ORDER BY name ASC");
    const groups = groupsResult.rows;

    // Get associations
    const assocResult = await pool.query(
      `SELECT rga.group_id, r.id, r.name, r.type
       FROM resource_group_association rga
       JOIN resource r ON rga.resource_id = r.id`
    );
    const associations = assocResult.rows;

    // Attach resources to groups
    groups.forEach((g) => {
      g.resources = associations
        .filter((a) => a.group_id === g.id)
        .map((a) => ({ id: a.id, name: a.name, type: a.type }));
    });

    res.json(groups);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch groups" });
  }
});

// Add a group
router.post("/", async (req, res) => {
  const { name, type, resourceIds } = req.body;
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    const groupResult = await client.query(
      "INSERT INTO resource_group (name, type) VALUES ($1, $2) RETURNING id, name, type",
      [name, type]
    );
    const group = groupResult.rows[0];
    for (const resourceId of resourceIds) {
      await client.query(
        "INSERT INTO resource_group_association (resource_id, group_id) VALUES ($1, $2)",
        [resourceId, group.id]
      );
    }
    await client.query("COMMIT");
    res.json(group);
  } catch (error) {
    await client.query("ROLLBACK");
    res.status(500).json({ error: "Failed to add group" });
  } finally {
    client.release();
  }
});

// Update a group (name/type/resources)
router.put("/:id", async (req, res) => {
  const { id } = req.params;
  const { name, type, resourceIds } = req.body;
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    await client.query(
      "UPDATE resource_group SET name = $1, type = $2 WHERE id = $3",
      [name, type, id]
    );
    await client.query(
      "DELETE FROM resource_group_association WHERE group_id = $1",
      [id]
    );
    for (const resourceId of resourceIds) {
      await client.query(
        "INSERT INTO resource_group_association (resource_id, group_id) VALUES ($1, $2)",
        [resourceId, id]
      );
    }
    await client.query("COMMIT");
    res.json({ success: true });
  } catch (error) {
    await client.query("ROLLBACK");
    res.status(500).json({ error: "Failed to update group" });
  } finally {
    client.release();
  }
});

// Delete a group
router.delete("/:id", async (req, res) => {
  const { id } = req.params;
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    await client.query("DELETE FROM resource_group_association WHERE group_id = $1", [id]);
    await client.query("DELETE FROM resource_group WHERE id = $1", [id]);
    await client.query("COMMIT");
    res.json({ success: true });
  } catch (error) {
    await client.query("ROLLBACK");
    res.status(500).json({ error: "Failed to delete group" });
  } finally {
    client.release();
  }
});

export default router;