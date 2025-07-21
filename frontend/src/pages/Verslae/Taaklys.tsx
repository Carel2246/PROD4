import { useEffect, useState } from "react";
import Layout from "../../components/Layout"; // Adjust path if needed

type ScheduledTask = {
  id: number; // Added this line
  task_number: string;
  job_description: string;
  customer: string;
  promised_date: string;
  start_time: string;
  end_time: string;
  resources_used: string;
  completed: boolean;
  task_description: string; // Added this line
};

function formatDate(dateStr: string) {
  if (!dateStr) return "";
  const d = new Date(dateStr);
  const dd = String(d.getDate()).padStart(2, "0");
  const mmm = d.toLocaleString("en-US", { month: "short" });
  const hh = String(d.getHours()).padStart(2, "0");
  const min = String(d.getMinutes()).padStart(2, "0");
  return `${dd} ${mmm} ${hh}:${min}`;
}

export default function Taaklys() {
  const [tasks, setTasks] = useState<ScheduledTask[]>([]);

  useEffect(() => {
    fetch("http://localhost:5000/api/reports/scheduled-tasks")
      .then((res) => res.json())
      .then(setTasks);
  }, []);

  const updateCompleted = (id: number, completed: boolean) => {
    fetch(`http://localhost:5000/api/tasks/${id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ completed }),
    }).then(() => {
      setTasks((prev) =>
        prev.map((t) => (t.id === id ? { ...t, completed } : t))
      );
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
                  <td className="p-2">{formatDate(t.start_time)}</td>
                  <td className="p-2">{formatDate(t.end_time)}</td>
                  <td className="p-2">{t.resources_used}</td>
                  <td className="p-2 text-center">
                    <input
                      type="checkbox"
                      checked={!!t.completed}
                      onChange={() => updateCompleted(t.id, !t.completed)}
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
