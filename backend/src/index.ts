import express from "express";
import dotenv from "dotenv";
import healthRouter from "./routes/health.js";
import jobsRouter from "./routes/jobs.js";
import tasksRouter from "./routes/tasks.js";
import materialsRouter from "./routes/materials.js";
import calendarRouter from "./routes/calendar.js";
import holidaysRouter from "./routes/holidays.js";
import resourcesRouter from "./routes/resources.js";
import resourceGroupsRouter from "./routes/resourceGroups.js";
import reportsRouter from "./routes/reports.js";
import cors from "cors";
import path from "path";
import { fileURLToPath } from "url";
import pg from "pg";

dotenv.config();  // Load from backend/.env

// DB test with individual options
const { Pool } = pg;
const pool = new Pool({
  host: 'localhost',
  port: 5432,
  database: 'prod4_dev',
  user: 'postgres',
  password: 'test123',
});
pool.query('SELECT 1', (err) => {
  if (err) console.error('❌ Failed to connect to DB:', err);
  else console.log('✅ DB connected');
});

// Add these lines at the top if using ES modules:
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const port = process.env.PORT || 5000;

app.use(
  cors({
    origin: "http://localhost:5173",
    credentials: true,
  })
);

app.use(express.json());
app.use("/api/health", healthRouter);
app.use("/api/jobs", jobsRouter);
app.use("/api/tasks", tasksRouter);
app.use("/api/materials", materialsRouter);
app.use("/api/calendar", calendarRouter);
app.use("/api/holidays", holidaysRouter);
app.use("/api/resources", resourcesRouter);
app.use("/api/resource-groups", resourceGroupsRouter);
app.use("/api/reports", reportsRouter);

// Serve static files from the React app
app.use(express.static(path.join(__dirname, "../../frontend/dist")));

// For any route not handled by your API, serve index.html
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "../../frontend/dist", "index.html"));
});

app.listen(port, () => {
  console.log(`API server running on http://localhost:${port}`);
});
