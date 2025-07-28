import { useEffect, useState } from "react";
import Layout from "../components/Layout";

type Resource = { id: number; name: string; type: string };
type Task = {
  id: number;
  task_number: string;
  job_number: string;
  description: string;
  resources: string;
  completed: boolean;
};
type Job = {
  job_number: string;
  description: string;
  customer: string;
};

export default function RuilHulpbronne() {
  const [resources, setResources] = useState<Resource[]>([]);
  const [tasks, setTasks] = useState<Task[]>([]);
  const [jobs, setJobs] = useState<Job[]>([]);
  const [selectedResource, setSelectedResource] = useState<number | null>(null);

  useEffect(() => {
    fetch("/api/resources")
      .then((res) => res.json())
      .then(setResources);
    fetch("/api/jobs")
      .then((res) => res.json())
      .then(setJobs);
  }, []);

  useEffect(() => {
    fetch("/api/tasks")
      .then((res) => res.json())
      .then((data) => setTasks(data.filter((t: Task) => !t.completed)));
  }, []);

  const filteredTasks = selectedResource
    ? tasks.filter((t) =>
        t.resources
          .split(",")
          .map((r) => r.trim())
          .includes(
            resources.find((r) => r.id === selectedResource)?.name || ""
          )
      )
    : [];

  const handleReplace = async (task: Task, newResourceName: string) => {
    const resourceNames = task.resources.split(",").map((r) => r.trim());
    const idx = resourceNames.indexOf(
      resources.find((r) => r.id === selectedResource)?.name || ""
    );
    if (idx === -1) return;
    resourceNames[idx] = newResourceName;
    const updatedResources = resourceNames.join(", ");
    await fetch(`/api/tasks/${task.id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ resources: updatedResources }),
    });
    setTasks((prev) =>
      prev.map((t) =>
        t.id === task.id ? { ...t, resources: updatedResources } : t
      )
    );
  };

  // Helper to get job info for a task
  const getJobInfo = (job_number: string) => {
    const job = jobs.find((j) => j.job_number === job_number);
    return job ? `${job.description} - ${job.customer}` : "";
  };

  return (
    <Layout>
      <h1 className="page-title">Ruil hulpbronne</h1>
      <div className="mb-4">
        <label className="mr-2">Kies hulpbron:</label>
        <select
          value={selectedResource ?? ""}
          onChange={(e) => setSelectedResource(Number(e.target.value))}
          className="input input-bordered"
        >
          <option value="">-- Kies --</option>
          {resources.map((r) => (
            <option key={r.id} value={r.id}>
              {r.name}
            </option>
          ))}
        </select>
      </div>
      {selectedResource && (
        <>
          <table className="min-w-full bg-white rounded shadow">
            <thead>
              <tr>
                <th className="p-2 text-left">#</th>
                <th className="p-2 text-left">Job beskrywing - kliënt</th>
                <th className="p-2 text-left">Taak</th>
                <th className="p-2 text-left">Huidige hulpbronne</th>
                <th className="p-2 text-left">Ruil met</th>
              </tr>
            </thead>
            <tbody>
              {filteredTasks.map((task) => (
                <tr key={task.id}>
                  <td className="p-2">{task.task_number}</td>
                  <td className="p-2">{getJobInfo(task.job_number)}</td>
                  <td className="p-2">{task.description}</td>
                  <td className="p-2">
                    {task.resources
                      .split(",")
                      .map((rid) => rid.trim())
                      .join(", ")}
                  </td>
                  <td className="p-2">
                    <select
                      value=""
                      onChange={(e) => handleReplace(task, e.target.value)}
                      className="input input-bordered"
                    >
                      <option value="">-- Kies nuwe hulpbron --</option>
                      {resources
                        .filter(
                          (r) =>
                            r.name !==
                            resources.find((r) => r.id === selectedResource)
                              ?.name
                        )
                        .map((r) => (
                          <option key={r.id} value={r.name}>
                            {r.name}
                          </option>
                        ))}
                    </select>
                  </td>
                </tr>
              ))}
              {filteredTasks.length === 0 && (
                <tr>
                  <td colSpan={5} className="text-center text-gray-500 p-4">
                    Geen take gevind vir hierdie hulpbron.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
          <button
            className="mt-4 px-4 py-2 border rounded border-nmi-accent text-nmi-accent bg-white hover:bg-nmi-accent hover:text-white transition"
            onClick={() => (window.location.href = "/hulpbronne")}
          >
            Terug na Hulpbronne
          </button>
        </>
      )}
    </Layout>
  );
}
