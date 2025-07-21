import express from "express";
import dotenv from "dotenv";
import healthRouter from "./routes/health";
import jobsRouter from "./routes/jobs";
import tasksRouter from "./routes/tasks";
import materialsRouter from "./routes/materials";
import calendarRouter from "./routes/calendar";
import holidaysRouter from "./routes/holidays";
import resourcesRouter from "./routes/resources";
import resourceGroupsRouter from "./routes/resourceGroups";
import reportsRouter from "./routes/reports";
import cors from "cors";

dotenv.config();

const app = express();
const port = process.env.PORT || 5000;

app.use(cors({
  origin: "http://localhost:5173",
  credentials: true
}));

app.use(express.json());
app.use("/api/health", healthRouter);
app.use("/api/jobs", jobsRouter);
app.use("/api/tasks", tasksRouter);
app.use("/api/materials", materialsRouter);
app.use("/api/resources", resourcesRouter);
app.use("/api/calendar", calendarRouter);
app.use("/api/holidays", holidaysRouter);
app.use("/api/resources", resourcesRouter);
app.use("/api/resource-groups", resourceGroupsRouter);
app.use("/api/reports", reportsRouter);

app.listen(port, () => {
  console.log(`API server running on http://localhost:${port}`);
});
