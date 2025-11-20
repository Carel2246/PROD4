import { useEffect, useState } from "react";
import Layout from "../../components/Layout"; // Adjust path if needed

type ScheduledTask = {
  id: number;
  task_number: string;
  job_description: string;
  customer: string;
  promised_date: string;
  start_time: string;
  end_time: string;
  resources_used: string;
  completed: boolean;
  busy: boolean; // <-- Add busy property
  task_description: string;
};

function formatDateLocal(dateStr: string) {
  if (!dateStr) return "";
  // Parse the date string as-is (no timezone adjustment) and format as DD/MM HH:MM
  const d = new Date(dateStr.replace(" ", "T")); // Assumes format like 'YYYY-MM-DD HH:MM:SS'
  const dd = String(d.getDate()).padStart(2, "0");
  const mm = String(d.getMonth() + 1).padStart(2, "0"); // Months are 0-based
  const hh = String(d.getHours()).padStart(2, "0");
  const min = String(d.getMinutes()).padStart(2, "0");
  return `${dd}/${mm} ${hh}:${min}`;
}

export default function Taaklys() {
  const [tasks, setTasks] = useState<ScheduledTask[]>([]);

  useEffect(() => {
    fetch("/api/reports/scheduled-tasks")
      .then((res) => res.json())
      .then((data) => {
        setTasks(data);
      });
  }, []);

  // Compute late jobs: group by job_description, check if max end_time > promised_date
  const lateJobs = new Set<string>();
  const jobGroups: { [key: string]: ScheduledTask[] } = {};
  tasks.forEach((t) => {
    if (!jobGroups[t.job_description]) jobGroups[t.job_description] = [];
    jobGroups[t.job_description].push(t);
  });
  Object.values(jobGroups).forEach((jobTasks) => {
    const maxEnd = Math.max(
      ...jobTasks
        .map((t) => (t.end_time ? new Date(t.end_time).getTime() : 0))
        .filter((time) => time > 0)
    );
    const promised = jobTasks[0].promised_date
      ? new Date(jobTasks[0].promised_date).getTime()
      : 0;
    if (maxEnd > promised && promised > 0) {
      lateJobs.add(jobTasks[0].job_description);
    }
  });

  const updateCompleted = (id: number, completed: boolean) => {
    fetch(`/api/tasks/${id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ completed }),
    }).then(() => {
      setTasks((prev) =>
        prev.map((t) => (t.id === id ? { ...t, completed } : t))
      );
    });
  };

  const updateBusy = (id: number, busy: boolean) => {
    fetch(`/api/tasks/${id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ busy }),
    })
      .then((res) => res.json())
      .then((updatedTask) => {
        // Update only the changed task in local state for instant UI feedback
        setTasks((prev) =>
          prev.map((t) => (t.id === id ? { ...t, busy: updatedTask.busy } : t))
        );
      })
      .catch(() => {
        // Optionally show an error message here
      });
  };

  return (
    <Layout>
      <div className="card p-4 mt-4">
        <h2 className="font-bold text-xl mb-4">Taaklys</h2>
        <table className="min-w-full text-sm">
          <thead>
            <tr className="bg-nmi-dark text-nmi-accent">
              <th className="p-2 text-left">Taak #</th>
              <th className="p-2 text-left">Bestelling</th>
              <th className="p-2 text-left">Beskrywing</th>
              <th className="p-2 text-left">Begin</th>
              <th className="p-2 text-left">Einde</th>
              <th className="p-2 text-left">Hulpbronne</th>
              <th className="p-2 text-left">Voltooi</th>
              <th className="p-2 text-left">Besig</th> {/* Busy column */}
            </tr>
          </thead>
          <tbody>
            {tasks.map((t) => {
              const isLate = lateJobs.has(t.job_description);
              return (
                <tr key={t.task_number} className="border-t">
                  <td className="p-2">{t.task_number}</td>
                  <td
                    className={`p-2 ${isLate ? "text-red-600 font-bold" : ""}`}
                  >
                    {t.job_description} - {t.customer}
                  </td>
                  <td className="p-2">{t.task_description}</td>
                  <td className="p-2">{formatDateLocal(t.start_time)}</td>
                  <td className="p-2">{formatDateLocal(t.end_time)}</td>
                  <td className="p-2">{t.resources_used}</td>
                  <td className="p-2 text-center">
                    <input
                      type="checkbox"
                      checked={!!t.completed}
                      onChange={() => {
                        updateCompleted(t.id, !t.completed);
                        if (!t.completed && t.busy) {
                          updateBusy(t.id, false);
                        }
                      }}
                    />
                  </td>
                  <td className="p-2 text-center">
                    <input
                      type="checkbox"
                      checked={!!t.busy}
                      onChange={() => updateBusy(t.id, !t.busy)}
                    />
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </Layout>
  );
}
