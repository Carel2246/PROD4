import express from "express";
import dotenv from "dotenv";
import healthRouter from "./routes/health";
import jobsRouter from "./routes/jobs";
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

app.listen(port, () => {
  console.log(`API server running on http://localhost:${port}`);
});
