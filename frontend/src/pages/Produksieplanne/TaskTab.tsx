import { useEffect, useState } from "react";
import ResourceMultiSelect from "./ResourceMultiSelect";

type Task = {
  id: number;
  task_number: number;
  description: string;
  duration_hours: number;
  predecessors: number[];
  resources: number[];
};

export default function TaskTab({ jobNumber }: { jobNumber: string }) {
  const [tasks, setTasks] = useState<Task[]>([]);

  const fetchTasks = () => {
    fetch(`http://localhost:5000/api/tasks/by-job/${jobNumber}`)
      .then((res) => res.json())
      .then(setTasks);
  };

  useEffect(() => {
    fetchTasks();
  }, [jobNumber]);

  const updateTask = (id: number, field: keyof Task, value: any) => {
    const updated = tasks.map((t) =>
      t.id === id ? { ...t, [field]: value } : t
    );
    setTasks(updated);

    fetch(`http://localhost:5000/api/tasks/${id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ [field]: value }),
    }).catch(console.error);
  };

  return (
    <div className="card p-4 mt-4">
      <h3 className="text-nmi-dark font-bold mb-2">🛠️ Take</h3>
      <div className="overflow-x-auto">
        <table className="min-w-full text-sm">
          <thead>
            <tr className="bg-nmi-dark text-nmi-accent">
              <th className="p-2">#</th>
              <th className="p-2">Beskrywing</th>
              <th className="p-2">Duur (u)</th>
              <th className="p-2">Afhanklikhede</th>
              <th className="p-2">Hulpbronne</th>
            </tr>
          </thead>
          <tbody>
            {tasks.map((task) => (
              <tr key={task.id} className="border-t hover:bg-gray-50">
                <td className="p-2">{task.task_number}</td>
                <td className="p-2">
                  <input
                    value={task.description}
                    className="form-input bg-nmi-light"
                    onChange={(e) =>
                      updateTask(task.id, "description", e.target.value)
                    }
                  />
                </td>
                <td className="p-2">
                  <input
                    type="number"
                    className="form-input bg-nmi-light"
                    value={task.duration_hours}
                    onChange={(e) =>
                      updateTask(
                        task.id,
                        "duration_hours",
                        Number(e.target.value)
                      )
                    }
                  />
                </td>
                <td className="p-2">
                  <input
                    className="form-input bg-nmi-light"
                    value={
                      Array.isArray(task.predecessors)
                        ? task.predecessors.join(", ")
                        : ""
                    }
                    onChange={(e) =>
                      updateTask(
                        task.id,
                        "predecessors",
                        e.target.value
                          .split(",")
                          .map((v) => parseInt(v.trim()))
                          .filter((n) => !isNaN(n))
                      )
                    }
                  />
                </td>
                <td className="p-2">
                  <ResourceMultiSelect
                    selected={task.resources}
                    onChange={(ids) => updateTask(task.id, "resources", ids)}
                    type="all" // supports all resource types
                  />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
