import { useEffect, useState } from "react";
import Layout from "../../components/Layout";
import * as XLSX from "xlsx";

type Resource = { id: number; name: string };
type ScheduledTask = {
  day: string;
  resource: string;
  task_number: string; // <-- Add this line
  job_description: string;
  customer: string;
  task_description: string;
};

function getDates(start: string, days: number) {
  const dates = [];
  const d = new Date(start);
  for (let i = 0; i < days; i++) {
    const copy = new Date(d);
    copy.setDate(d.getDate() + i);
    dates.push(copy.toISOString().slice(0, 10));
  }
  return dates;
}

function formatDate(dateStr: string) {
  const d = new Date(dateStr);
  const dd = String(d.getDate()).padStart(2, "0");
  const mmm = d.toLocaleString("en-US", { month: "short" });
  return `${dd} ${mmm}`;
}

export default function Skedule() {
  const [days, setDays] = useState(7);
  const [resources, setResources] = useState<Resource[]>([]);
  const [tasks, setTasks] = useState<ScheduledTask[]>([]);
  const [startDate, setStartDate] = useState<string>("");

  useEffect(() => {
    console.log("Fetching with days:", days);
    fetch(`http://localhost:5000/api/reports/resource-schedule?days=${days}`)
      .then((res) => res.json())
      .then((data) => {
        console.log("Received data:", data);
        setResources(data.resources);
        setTasks(data.tasks);
        setStartDate(data.startDate.slice(0, 10));
      })
      .catch((error) => {
        console.error("Failed to fetch schedule:", error);
      });
  }, [days]);

  const dates = startDate ? getDates(startDate, days) : [];

  function exportToExcel() {
    const now = new Date();
    const yyyymmdd = now.toISOString().slice(0, 10).replace(/-/g, "");
    const timeStr = now.toLocaleString();

    // Prepare header row: first cell is "Persoon", then dates
    const header = ["Persoon", ...dates.map((date) => formatDate(date))];

    // Prepare data rows
    const rows = resources.map((r) => {
      const row = [r.name];
      dates.forEach((date) => {
        const cellTasks = tasks.filter((t) => {
          const taskDay = t.day ? t.day.slice(0, 10) : "";
          const resourceName = t.resource
            ? t.resource.trim().toLowerCase()
            : "";
          const rowResource = r.name ? r.name.trim().toLowerCase() : "";
          return taskDay === date && resourceName === rowResource;
        });
        const cellText = cellTasks
          .map((t) => {
            const sameTaskResources = tasks
              .filter(
                (other) =>
                  other.task_number === t.task_number &&
                  (other.day ? other.day.slice(0, 10) : "") === date
              )
              .map((other) => (other.resource ? other.resource.trim() : ""))
              .filter(
                (name) => name.toLowerCase() !== r.name.trim().toLowerCase()
              );
            return (
              `${t.job_description} - ${t.customer} (${t.task_description})` +
              (sameTaskResources.length > 0
                ? ` (Saam ${sameTaskResources.join(", ")})`
                : "")
            );
          })
          .join("\n");
        row.push(cellText);
      });
      return row;
    });

    // Add date/time at the top
    const sheetData = [
      [`Skedule gegenereer op: ${timeStr}`],
      [],
      header,
      ...rows,
    ];

    const ws = XLSX.utils.aoa_to_sheet(sheetData);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Skedule");

    XLSX.writeFile(wb, `NMI Skedule ${yyyymmdd}.xlsx`);
  }

  return (
    <Layout>
      <div className="card p-4 mt-4">
        <h2 className="font-bold text-xl mb-4">Skedule</h2>
        <div className="mb-4 flex items-center gap-4">
          <button
            className="px-4 py-2 bg-nmi-accent text-white rounded shadow"
            onClick={exportToExcel}
          >
            Export to Excel
          </button>
          <label className="font-semibold">Dae:</label>
          <input
            type="range"
            min={1}
            max={31}
            value={days}
            onChange={(e) => setDays(Number(e.target.value))}
          />
          <span>{days}</span>
        </div>
        <div className="overflow-x-auto">
          <table
            className="text-sm border"
            style={{
              minWidth: days > 5 ? `${5 * 180}px` : "100%",
              width: days > 5 ? `${days * 180}px` : "100%",
            }}
          >
            <thead>
              <tr>
                <th className="p-2 text-left bg-nmi-dark text-nmi-accent border border-nmi-accent">
                  Persoon
                </th>
                {dates.map((date) => (
                  <th
                    key={date}
                    className="p-2 text-left bg-nmi-dark text-nmi-accent border border-nmi-accent"
                    style={{ minWidth: "180px" }}
                  >
                    {formatDate(date)}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {resources.map((r) => (
                <tr key={r.name} className="border-t">
                  <td className="p-2 font-semibold border border-nmi-accent">
                    {r.name}
                  </td>
                  {dates.map((date) => {
                    const cellTasks = tasks.filter((t) => {
                      const taskDay = t.day ? t.day.slice(0, 10) : "";
                      const resourceName = t.resource
                        ? t.resource.trim().toLowerCase()
                        : "";
                      const rowResource = r.name
                        ? r.name.trim().toLowerCase()
                        : "";
                      return taskDay === date && resourceName === rowResource;
                    });
                    return (
                      <td
                        key={date}
                        className="p-2 align-top border border-nmi-accent"
                      >
                        <ul className="list-disc pl-4">
                          {cellTasks.map((t, i) => {
                            // Find other resources assigned to this task on this day
                            const sameTaskResources = tasks
                              .filter(
                                (other) =>
                                  other.task_number === t.task_number &&
                                  (other.day ? other.day.slice(0, 10) : "") ===
                                    date
                              )
                              .map((other) =>
                                other.resource ? other.resource.trim() : ""
                              )
                              .filter(
                                (name) =>
                                  name.toLowerCase() !==
                                  r.name.trim().toLowerCase()
                              );

                            return (
                              <li key={i} className="mb-1">
                                {t.job_description} - {t.customer} (
                                {t.task_description})
                                {sameTaskResources.length > 0 && (
                                  <span className="ml-2 text-xs text-gray-500">
                                    (Saam {sameTaskResources.join(", ")})
                                  </span>
                                )}
                              </li>
                            );
                          })}
                        </ul>
                      </td>
                    );
                  })}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </Layout>
  );
}
