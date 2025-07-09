import { Router } from "express";

const router = Router();

router.get("/", (req, res) => {
  res.json({ status: "ok", message: "NMI Produksie API is alive" });
});

export default router;
