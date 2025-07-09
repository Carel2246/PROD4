# 🏭 NMI Produksie – Project Summary & Status

---

## 📌 Project Overview

**NMI Produksie** is a production management web application built for a steel fabrication workshop. It handles 4–5 concurrent job plans with 15–20 open tasks at any time. The goal is to streamline factory-floor operations using real-time task tracking, digital travelers, and automated job-shop scheduling.

---

## 🎯 MVP Core Objectives

- ✅ Real-time job/task tracking
- ✅ Digital traveler system (PDF, DXF, STEP, SolidWorks files)
- ✅ Automated scheduling (Google OR-Tools)
- ✅ Mobile-first floor interface
- ✅ Interactive UI: Gantt charts, flow diagrams, resource dashboards

---

## 🏗️ Tech Stack

| Layer        | Technology                        | Notes                                     |
| ------------ | --------------------------------- | ----------------------------------------- |
| Frontend     | React (TypeScript) + Tailwind CSS | Responsive, mobile-first UI               |
| Backend      | Node.js + Express + TypeScript    | API + real-time endpoints                 |
| Database     | PostgreSQL (hosted on Azure)      | Schema defined in `/verwysing/schema.sql` |
| Scheduler    | Python + OR-Tools                 | Local execution, integrated later via API |
| CI/CD        | GitHub Actions                    | Automated linting and testing             |
| Version Ctrl | Git + GitHub                      | Repo managed via VSCode integration       |

---

## 📂 Folder Structure

Prod4/
├── backend/ # Node.js + Express backend (TS)
│ └── src/
│ └── index.ts # Entry point
│ └── .env # Azure database environment variables
│
├── frontend/ # React frontend with Tailwind
│ └── src/
└── components
└── pages
│ ├── main.tsx # Entry point
│ └── index.css # All styling must come from here - NONE inline
│
├── scheduler/ # Local OR-Tools scheduler
│ ├── venv/ # Python virtualenv
│ ├── main.py # Scheduler runner
│ └── requirements.txt
│
├── verwysing/ # Reference folder for docs/schemas
│ ├── Produksie.md # <== THIS FILE
│ ├── routes.md # <== ROUTES DEFINED SO AS TO MINIMIZE DUPLICATION OF SAME OR SIMILAR ROUTES
│ └── schema.sql # DB structure from Azure
│
├── .github/workflows/
│ └── ci.yml # GitHub Actions workflow
|
└── README.md # Optional repo entry summary

---

## 🧪 Database Info

- **Live Database Name:** `jobshopdb`
- **Hosted on:** Azure PostgreSQL
- Full schema in: `/verwysing/schema.sql`

---

## 📋 MVP Implementation Plan & Task Status

| ID  | Task Description                                                    | Status                                 |
| --- | ------------------------------------------------------------------- | -------------------------------------- |
| 1.1 | Select full-stack tech architecture                                 | ✅ Complete                            |
| 1.2 | Scaffold project folder structure                                   | ✅ Complete                            |
| 1.3 | Set up local dev environments (venv, linters, GitHub CI)            | ✅ Complete                            |
| 1.4 | Set up backend API project with Express + TypeScript                | 🔜 Next                                |
| 1.5 | Confirm database setup on Azure                                     | ✅ Complete                            |
| 2.1 | Implement scheduling logic (Google OR-Tools)                        | ⏸️ Deferred (working local PoC exists) |
| 3.1 | Create CRUD API: jobs, tasks, resources, templates                  | 🔜                                     |
| 3.2 | Connect backend to Azure PostgreSQL                                 | 🔜                                     |
| 3.3 | Add WebSocket or polling endpoints for real-time status             | 🔜                                     |
| 4.1 | Scaffold frontend React app with routing + UI structure             | ✅ (basic scaffold)                    |
| 4.2 | Create mobile-friendly floor interface for task updates             | 🔜                                     |
| 4.3 | Integrate Gantt charts, flow diagrams, and dashboards               | 🔜                                     |
| 5.1 | Implement digital traveler file viewer (PDF, DXF, STEP, SolidWorks) | 🔜                                     |
| 6.1 | Deploy production version to Azure                                  | 🔜 Post-MVP                            |
| 6.2 | Final QA and user acceptance testing                                | 🔜 Post-MVP                            |

---

## 🤖 Roles & Responsibilities

| Role              | Responsibility                                          |
| ----------------- | ------------------------------------------------------- |
| **You (Client)**  | Define requirements, factory process insight            |
| **Me (Lead Dev)** | Architecture, planning, coding, tech guidance           |
| **Other AIs**     | Optional help (Grok, Gemini, Claude) as needed per task |

---

## ⚙️ CI Pipeline Summary (`ci.yml`)

Configured GitHub Actions workflow:

- Lints backend (`npm run lint`)
- Runs scheduler (`python main.py`)
- Extensible to include tests or deploy steps later

---

## 🧠 Notes for New Developers / AI Systems

This file provides enough context to onboard a new contributor or AI assistant.

- Use `schema.sql` to understand the data model
- Backend: Node.js (Express) + Azure PostgreSQL
- Frontend: React + Tailwind
- Scheduler: Python + OR-Tools, local-only for now
- No Docker used — all tools run natively
- Development is in VSCode, GitHub-connected

---
