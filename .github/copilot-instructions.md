# PROD4 Copilot Instructions

## Architecture Overview

- **Monorepo Structure:**
  - `frontend/`: React (Vite) SPA for resource/resource group management, scheduling, and reporting. All UI in Afrikaans. Key pages: `Hulpbronne.tsx`, `RuilHulpbronne.tsx`, `Produksieplanne/`, `Verslae/`.
  - `backend/`: Node.js/Express REST API (TypeScript, ES modules, explicit `.js` imports). Serves API under `/api/*`, connects directly to Azure PostgreSQL. API routes in `backend/src/routes/`, one file per resource type.
  - `scheduler/`: Standalone Python app (PySide6 GUI, OR-tools). Connects directly to Azure PostgreSQL, loads jobs/tasks/resources for advanced job shop scheduling. Main logic in `scheduler/scheduler.py`, GUI in `scheduler/gui.py`.
  - `verwysing/`: Reference docs, schema, and planning files. DB schema in `verwysing/schema.sql`.

## Data Flow & Integration

- **Database:** Centralized Azure PostgreSQL. Both backend and scheduler use direct SQL queries for CRUD and scheduling data. Schema: `verwysing/schema.sql`.
- **Frontend/Backend:** Frontend fetches data via REST API (`/api/*`). Backend PATCH endpoints support updating resources and other fields for tasks/jobs. All API routes in `backend/src/routes/`.
- **Scheduler:** Python scheduler loads jobs/tasks/resources directly from DB, not via backend API. Scheduling logic in `scheduler/scheduler.py` (uses OR-tools (CP-SAT) for advanced job shop scheduling, resolves resource groups to available resources, respects predecessors, holidays, working hours).  
  **Scheduling rules:**
  - Working hours are found in the `calendar` table (`weekday`, `start_time`, `end_time`).
  - The `resources` column of a task can contain multiple comma-separated values. Each value can correspond to the name of a `[resource]` or a `[resource_group]`.
    - If it matches a `[resource]`, that resource must be assigned.
    - If it matches a `[resource_group]`, the resource from that group (found in `[resource_group_association]`) that results in the best schedule should be assigned.
  - All resources must be satisfied for a task to start (if 3 resources are required, all 3 must be available).
  - All predecessors must be satisfied (if 3 predecessors are required, all 3 must be scheduled to be completed before the task can start).

## Developer Workflows

- **Build/Run:**
  - Root: `npm run build` (builds frontend/backend), `npm start` (runs backend, serves built frontend).
  - Scheduler: Activate venv, run `python main.py` for GUI, or `python scheduler.py` for CLI scheduling.
- **Deployment:** Azure App Service deploys from root, expects both frontend and backend to be built. Python scheduler runs as a separate app, not part of main deployment pipeline. CI/CD in `.github/workflows/deploy.yml`.

## Project-Specific Patterns

- **Resource Assignment:** Tasks may require multiple resources/groups (comma-separated names in DB/UI). Resource groups resolved to available resources at scheduling time (see `scheduler/scheduler.py`).
- **Scheduling Constraints:** Predecessors, holidays, working hours, and resource group logic handled in Python (`scheduler/scheduler.py`). If a task has incomplete predecessors, those are scheduled first (even if not busy). Completed predecessors do not block scheduling.
- **Frontend UI:** All UI labels/messages in Afrikaans. Resource management and swapping in `Hulpbronne.tsx` and `RuilHulpbronne.tsx`. Busy/completed status managed via PATCH endpoints; ticking completed also unticks busy.
- **Backend API:** TypeScript, ES modules, explicit `.js` extensions in imports. PATCH endpoints support updating fields including `busy` and `completed`.

## Key Files & Directories

- `frontend/src/pages/`: Main React pages, including resource and scheduling UIs.
- `backend/src/routes/`: API route handlers, one file per resource type.
- `scheduler/scheduler.py`: Main scheduling logic (OR-tools (CP-SAT), resource assignment, time conversion).
- `scheduler/gui.py`: PySide6 GUI for running and visualizing schedules.
- `.github/workflows/deploy.yml`: CI/CD pipeline for Azure deployment.
- `verwysing/schema.sql`: Database schema reference.

## Example: Adding a New Resource Type

- Update DB schema in `verwysing/schema.sql`.
- Add API route in `backend/src/routes/resources.ts`.
- Update frontend UI in `frontend/src/pages/Hulpbronne.tsx`.
- Update scheduler logic in `scheduler/scheduler.py` if needed.

## Guidance for AI Agents

- Always use explicit `.js` extensions in TypeScript/Node.js imports in backend code.
- When updating resource assignment logic, update both DB schema and scheduler logic for group resolution.
- For scheduling logic, reference `scheduler/scheduler.py` for handling holidays, working hours, and resource group assignment.
- All frontend UI text must be in Afrikaans; see existing pages for conventions.
- When adding new API endpoints, follow the pattern in `backend/src/routes/` (one file per resource type).
- For database changes, update both schema and relevant loader logic in scheduler/backend.

---

**Scheduling Logic Reference (Python Scheduler):**

- **Werksure (Working Hours):**

  - Found in the `calendar` table (`weekday`, `start_time`, `end_time`).
  - Used to determine when resources are available for scheduling.

- **Resources for Tasks:**

  - The `resources` column in the `task` table can contain multiple comma-separated values.
  - Each value can be:
    - The name of a `resource` (from the `resource` table): assign that specific resource.
    - The name of a `resource_group` (from the `resource_group` table): assign the best available resource from that group (using `resource_group_association`).
      - "Best" means the resource that results in the earliest feasible schedule.

- **Resource Assignment:**

  - All resources listed for a task must be assigned and available for the task to start.
  - If a task requires multiple resources/groups, all must be satisfied simultaneously.

- **Predecessor Constraints:**
  - The `predecessors` column in the `task` table can contain multiple comma-separated values (task_numbers).
  - All listed predecessors must be scheduled to complete before the current task can start.
  - If a predecessor is already completed, it does not block scheduling.

---

**Feedback Requested:**

- Are there any undocumented workflows, conventions, or integration points?
- Is any part of the architecture or workflow unclear or missing?
- Please specify any custom scripts, environment variables, or deployment steps
