import { useEffect, useState } from "react";
import { useSearchParams, useNavigate } from "react-router-dom";
import Layout from "../../components/Layout";

type Task = {
  id: number;
  job_number: string;
  task_number: string;
  description: string;
  setup_time: number;
  time_each: number;
  predecessors: string;
  resources: string;
  completed: boolean;
  completed_at: string | null;
  busy: boolean;
};

export default function TaskEdit() {
  const [searchParams] = useSearchParams();
  const taskId = searchParams.get("taskId");
  const issue = searchParams.get("issue");
  const [task, setTask] = useState<Task | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    if (taskId) {
      fetch("/api/tasks/" + taskId)
        .then((res) => res.json())
        .then(setTask)
        .catch((err) => console.error("Failed to fetch task:", err));
    }
  }, [taskId]);

  const saveTask = () => {
    if (!task) return;
    return fetch("/api/tasks/" + task.id, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(task),
    });
  };

  const updateField = (field: keyof Task, value: any) => {
    if (!task) return;

    const updated = { ...task, [field]: value };
    setTask(updated);

    fetch("/api/tasks/" + task.id, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ [field]: value }),
    }).catch((err) => console.error("Update failed:", err));
  };

  if (!task)
    return (
      <Layout>
        <div>Loading...</div>
      </Layout>
    );

  return (
    <Layout>
      <h1 className="page-title">
        'n Probleem is gevind met die volgende taak
      </h1>
      <p className="text-lg mb-4">
        Die fout lê by: {issue === "circular" ? "afhanklikhede" : "hulpbronne"}
      </p>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <FormRow label="Job Number">
          <input
            className="form-input"
            value={task.job_number}
            onChange={(e) => updateField("job_number", e.target.value)}
          />
        </FormRow>

        <FormRow label="Task Number">
          <input
            className="form-input"
            value={task.task_number}
            onChange={(e) => updateField("task_number", e.target.value)}
          />
        </FormRow>

        <FormRow label="Description">
          <input
            className="form-input"
            value={task.description}
            onChange={(e) => updateField("description", e.target.value)}
          />
        </FormRow>

        <FormRow label="Setup Time">
          <input
            type="number"
            className="form-input"
            value={task.setup_time}
            onChange={(e) => updateField("setup_time", Number(e.target.value))}
          />
        </FormRow>

        <FormRow label="Time Each">
          <input
            type="number"
            className="form-input"
            value={task.time_each}
            onChange={(e) => updateField("time_each", Number(e.target.value))}
          />
        </FormRow>

        <FormRow label="Predecessors">
          <input
            className="form-input"
            value={task.predecessors || ""}
            onChange={(e) => updateField("predecessors", e.target.value)}
          />
        </FormRow>

        <FormRow label="Resources">
          <input
            className="form-input"
            value={task.resources || ""}
            onChange={(e) => updateField("resources", e.target.value)}
          />
        </FormRow>

        <FormRow label="Completed">
          <input
            type="checkbox"
            className="h-5 w-5"
            checked={task.completed}
            onChange={(e) => updateField("completed", e.target.checked)}
          />
        </FormRow>

        <FormRow label="Busy">
          <input
            type="checkbox"
            className="h-5 w-5"
            checked={task.busy}
            onChange={(e) => updateField("busy", e.target.checked)}
          />
        </FormRow>
      </div>

      <div className="mt-6">
        <button
          className="px-4 py-2 bg-blue-500 text-white rounded"
          onClick={async () => {
            await saveTask();
            navigate("/produksieplanne", {
              state: { selectedJob: task.job_number },
            });
          }}
        >
          Gaan voort
        </button>
      </div>
    </Layout>
  );
}

function FormRow({
  label,
  children,
}: {
  label: string;
  children: React.ReactNode;
}) {
  return (
    <div className="flex flex-col">
      <label className="text-sm text-nmi-dark mb-1">{label}</label>
      {children}
    </div>
  );
}
