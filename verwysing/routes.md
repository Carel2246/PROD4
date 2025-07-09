# 🌐 API Route Index

Organized by resource group. Use this file to reference existing endpoints to avoid duplication.

---

## 📁 /api/jobs

| Method | Path                 | Description              | Tags               |
| ------ | -------------------- | ------------------------ | ------------------ |
| GET    | /api/jobs/incomplete | List all incomplete jobs | @reusable, @report |

---

## 📁 /api/tasks

_(... later on)_

---

## 📁 /api/resources

_(... later on)_

---

## 🧠 Notes

- Reusable endpoints (like `/jobs/incomplete`) should be kept generic and used in multiple frontend views.
- Routes that are used only in admin/config pages can include `@admin`.
- Avoid creating near-duplicate filters if the backend route can take a query param (e.g., `/jobs?status=incomplete` instead of creating many versions).
