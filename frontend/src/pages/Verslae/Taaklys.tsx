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
  // Parse as UTC (append 'Z' to treat as UTC) and display as local time (Afrikaans format)
  const d = new Date(dateStr.replace(" ", "T") + "Z"); // Assumes format like 'YYYY-MM-DD HH:MM:SS'
  const dd = String(d.getDate()).padStart(2, "0");
  const mmm = d.toLocaleString("af-ZA", { month: "short" });
  const hh = String(d.getHours()).padStart(2, "0");
  const min = String(d.getMinutes()).padStart(2, "0");
  return `${dd} ${mmm} ${hh}:${min}`;
}

export default function Taaklys() {
  const [tasks, setTasks] = useState<ScheduledTask[]>([]);

  useEffect(() => {
    fetch("/api/reports/scheduled-tasks")
      .then((res) => res.json())
      .then(setTasks);
  }, []);

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
              const isLate =
                t.end_time && t.promised_date
                  ? new Date(t.end_time) > new Date(t.promised_date)
                  : false;
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
