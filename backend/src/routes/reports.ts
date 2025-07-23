import { Router } from "express";
import pool from "../config/db.js";

const router = Router();

router.get("/scheduled-tasks", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        t.id, -- Add this line
        t.task_number,
        j.description AS job_description,
        j.customer,
        j.promised_date,
        t.description AS task_description,
        s.start_time,
        s.end_time,
        s.resources_used,
        t.completed
      FROM schedule s
      JOIN task t ON t.task_number = s.task_number
      JOIN job j ON j.job_number = t.job_number
      ORDER BY s.start_time ASC
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch scheduled tasks" });
  }
});

router.get("/resource-schedule", async (req, res) => {
  try {
    const { days = 7, start } = req.query;
    const startDateResult = await pool.query(`SELECT MIN(start_time) AS min_date FROM schedule`);
    const minDate = startDateResult.rows[0].min_date;
    const startStr = Array.isArray(start) ? start[0] : start;
    const startDate = startStr ? new Date(startStr as string) : new Date(minDate);
    const endDate = new Date(startDate);
    endDate.setDate(startDate.getDate() + Number(days) - 1);

    // Get all resources of type "H"
    const resourcesRes = await pool.query(`
      SELECT id, name 
      FROM resource 
      WHERE type = 'H' 
      ORDER BY name
    `);

    // Split resources and return with correct field name
    const tasksRes = await pool.query(`
      WITH split_resources AS (
        SELECT 
          s.start_time::date AS day,
          TRIM(unnest(string_to_array(s.resources_used, ','))) AS resource,
          t.task_number,
          t.description AS task_description,
          j.description AS job_description,
          j.customer
        FROM schedule s
        JOIN task t ON t.task_number = s.task_number
        JOIN job j ON j.job_number = t.job_number
        WHERE s.start_time::date >= $1 
        AND s.start_time::date <= $2
      )
      SELECT sr.*
      FROM split_resources sr
      JOIN resource r ON r.name = sr.resource AND r.type = 'H'
      ORDER BY sr.resource, sr.day
    `, [startDate, endDate]);

    res.json({
      resources: resourcesRes.rows,
      tasks: tasksRes.rows,
      startDate: startDate.toISOString().slice(0, 10),
      endDate: endDate.toISOString().slice(0, 10),
    });
  } catch (error) {
    console.error('Error in resource-schedule:', error);
    res.status(500).json({ error: 'Failed to fetch resource schedule' });
  }
});

export default router;