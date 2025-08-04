import { useEffect, useState } from "react";
import TaskFlowchart from "./TaskFlowchart";

type Resource = {
  id: number;
  name: string;
  type: string;
};

type ResourceGroup = {
  id: number;
  name: string;
  type: string;
};

type Task = {
  completed: any;
  id: number;
  task_number: string;
  description: string;
  duration_hours?: number;
  setup_time: number;
  time_each: number;
  predecessors: string[];
  resources: string[];
  busy: boolean; // <-- Add busy property
};

function parseStringArray(str: string | null | undefined): string[] {
  if (!str) return [];
  return str
    .split(",")
    .map((v) => v.trim())
    .filter((v) => v.length > 0);
}

function getSequence(taskNumber: string): string {
  const parts = taskNumber.split("-");
  return parts.length > 1 ? parts[1] : "";
}

function setSequence(taskNumber: string, newSeq: string): string {
  const parts = taskNumber.split("-");
  return parts.length > 1 ? `${parts[0]}-${newSeq}` : taskNumber;
}

function displayPredecessors(predecessors: string[]): string {
  // Show only the sequence part
  return predecessors
    .map((p) => {
      const parts = p.split("-");
      return parts.length > 1 ? parts[1] : p;
    })
    .join(", ");
}

function savePredecessors(input: string, jobNumber: string): string[] {
  // Convert user input (sequence numbers) to full format
  return input
    .split(",")
    .map((v) => v.trim())
    .filter((v) => v.length > 0)
    .map((seq) => `${jobNumber}-${seq}`);
}

export default function TaskTab({
  jobNumber,
  onJobStatusChange,
  refreshTasksTrigger,
}: {
  jobNumber: string;
  onJobStatusChange?: () => void;
  refreshTasksTrigger?: boolean;
}) {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [resources, setResources] = useState<Resource[]>([]);
  const [groups, setGroups] = useState<ResourceGroup[]>([]);
  const [adding, setAdding] = useState(false);
  const [editingDescriptions, setEditingDescriptions] = useState<{
    [id: number]: string;
  }>({});
  const [editingPredecessors, setEditingPredecessors] = useState<{
    [id: number]: string;
  }>({});

  // Modal state
  const [modalOpen, setModalOpen] = useState(false);
  const [modalTaskId, setModalTaskId] = useState<number | null>(null);
  const [modalSelected, setModalSelected] = useState<string[]>([]);

  // Fetch resources and groups
  useEffect(() => {
    fetch("/api/resources")
      .then((res) => res.json())
      .then(setResources);
    fetch("/api/resource-groups")
      .then((res) => res.json())
      .then(setGroups);
  }, []);

  // Fetch tasks
  const fetchTasks = () => {
    fetch(`/api/tasks/by-job/${jobNumber}`)
      .then((res) => res.json())
      .then((data) =>
        setTasks(
          data
            .map((t: any) => ({
              ...t,
              predecessors: parseStringArray(t.predecessors),
              resources: parseStringArray(t.resources),
              busy: !!t.busy, // <-- Ensure busy is boolean
            }))
            .sort(
              (a: any, b: any) =>
                parseInt(getSequence(a.task_number)) -
                parseInt(getSequence(b.task_number))
            )
        )
      );
  };

  useEffect(() => {
    fetchTasks();
  }, [jobNumber, refreshTasksTrigger]);

  // Update task
  const updateTask = (id: number, field: keyof Task, value: any) => {
    const updated = tasks.map((t) =>
      t.id === id ? { ...t, [field]: value } : t
    );
    setTasks(updated);

    let sendValue = value;
    if (field === "predecessors" || field === "resources") {
      sendValue = Array.isArray(value) ? value.join(",") : "";
    }

    fetch(`/api/tasks/${id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ [field]: sendValue }),
    })
      .then(() => {
        // After updating the task, fetch the latest tasks and update job status
        fetch(`/api/tasks/by-job/${jobNumber}`)
          .then((res) => res.json())
          .then((data) => {
            const allCompleted = data.every((t: any) => !!t.completed);
            fetch(`/api/jobs/${jobNumber}`, {
              method: "PATCH",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify({ completed: allCompleted }),
            })
              .then(() => {
                if (onJobStatusChange) onJobStatusChange();
              })
              .catch(console.error);
            setTasks(
              data
                .map((t: any) => ({
                  ...t,
                  predecessors: parseStringArray(t.predecessors),
                  resources: parseStringArray(t.resources),
                }))
                .sort(
                  (a: any, b: any) =>
                    parseInt(getSequence(a.task_number)) -
                    parseInt(getSequence(b.task_number))
                )
            );
          });
      })
      .catch(console.error);
  };

  // Sequence update
  const updateSequence = (id: number, newSeq: string) => {
    const task = tasks.find((t) => t.id === id);
    if (!task) return;
    const newTaskNumber = setSequence(task.task_number, newSeq);
    updateTask(id, "task_number", newTaskNumber);
  };

  // Add task
  const addTask = () => {
    setAdding(true);
    fetch(`/api/tasks`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        job_number: jobNumber,
        task_number: `${jobNumber}-${
          tasks.length > 0
            ? Math.max(
                ...tasks.map((t) => parseInt(getSequence(t.task_number)) || 0)
              ) + 1
            : 1
        }`,
        description: "",
        setup_time: 0,
        time_each: 0,
        predecessors: "",
        resources: "",
        completed: false,
        completed_at: null,
      }),
    })
      .then(() => {
        fetchTasks();
        setAdding(false);
      })
      .catch(() => setAdding(false));
  };

  // Delete task
  const deleteTask = (id: number) => {
    if (!window.confirm("Are you sure you want to delete this task?")) return;
    fetch(`/api/tasks/${id}`, {
      method: "DELETE",
    }).then(fetchTasks);
  };

  // Modal open
  const openResourceModal = (task: Task) => {
    setModalTaskId(task.id);
    setModalSelected(task.resources);
    setModalOpen(true);
  };

  // Modal save
  const saveResourceModal = () => {
    if (modalTaskId !== null) {
      updateTask(modalTaskId, "resources", modalSelected);
    }
    setModalOpen(false);
    setModalTaskId(null);
    setModalSelected([]);
  };

  // Display resource names
  const getResourceNames = (names: string[]) =>
    names.length > 0 ? (
      names.join(", ")
    ) : (
      <span className="text-gray-400">Geen</span>
    );

  return (
    <div className="card p-4 mt-4">
      <h3 className="text-nmi-dark font-bold mb-2">🛠️ Take</h3>
      <div className="overflow-x-auto">
        <table className="min-w-full text-sm">
          <thead>
            <tr className="bg-nmi-dark text-nmi-accent">
              <th className="p-2">#</th>
              <th className="p-2">Beskrywing</th>
              <th className="p-2">Opstel (min)</th>
              <th className="p-2">Tyd Elk (min)</th>
              <th className="p-2">Afhanklikhede</th>
              <th className="p-2">Hulpbronne</th>
              <th className="p-2 text-green-600" title="Voltooi">
                ✅
              </th>
              <th className="p-2 text-blue-600" title="Besig">
                🟦
              </th>
              <th className="p-2"></th>
            </tr>
          </thead>
          <tbody>
            {tasks.map((task) => (
              <tr key={task.id} className="border-t hover:bg-gray-50">
                <td className="p-2">
                  <input
                    className="form-input bg-nmi-light w-16"
                    value={getSequence(task.task_number)}
                    onChange={(e) => updateSequence(task.id, e.target.value)}
                  />
                </td>
                <td className="p-2">
                  <input
                    value={
                      editingDescriptions[task.id] !== undefined
                        ? editingDescriptions[task.id]
                        : task.description
                    }
                    className="form-input bg-nmi-light"
                    onChange={(e) =>
                      setEditingDescriptions((prev) => ({
                        ...prev,
                        [task.id]: e.target.value,
                      }))
                    }
                    onBlur={() => {
                      if (
                        editingDescriptions[task.id] !== undefined &&
                        editingDescriptions[task.id] !== task.description
                      ) {
                        updateTask(
                          task.id,
                          "description",
                          editingDescriptions[task.id]
                        );
                      }
                      setEditingDescriptions((prev) => {
                        const copy = { ...prev };
                        delete copy[task.id];
                        return copy;
                      });
                    }}
                    onKeyDown={(e) => {
                      if (e.key === "Enter") {
                        e.currentTarget.blur();
                      }
                    }}
                  />
                </td>
                <td className="p-2">
                  <input
                    type="number"
                    className="form-input bg-nmi-light"
                    value={task.setup_time}
                    onChange={(e) =>
                      updateTask(task.id, "setup_time", Number(e.target.value))
                    }
                  />
                </td>
                <td className="p-2">
                  <input
                    type="number"
                    className="form-input bg-nmi-light"
                    value={task.time_each}
                    onChange={(e) =>
                      updateTask(task.id, "time_each", Number(e.target.value))
                    }
                  />
                </td>
                <td className="p-2">
                  <input
                    className="form-input bg-nmi-light"
                    value={
                      editingPredecessors[task.id] !== undefined
                        ? editingPredecessors[task.id]
                        : displayPredecessors(task.predecessors)
                    }
                    onChange={(e) =>
                      setEditingPredecessors((prev) => ({
                        ...prev,
                        [task.id]: e.target.value,
                      }))
                    }
                    onBlur={() => {
                      if (
                        editingPredecessors[task.id] !== undefined &&
                        editingPredecessors[task.id] !==
                          displayPredecessors(task.predecessors)
                      ) {
                        updateTask(
                          task.id,
                          "predecessors",
                          savePredecessors(
                            editingPredecessors[task.id],
                            jobNumber
                          )
                        );
                      }
                      setEditingPredecessors((prev) => {
                        const copy = { ...prev };
                        delete copy[task.id];
                        return copy;
                      });
                    }}
                    onKeyDown={(e) => {
                      if (e.key === "Enter") {
                        e.currentTarget.blur();
                      }
                    }}
                    placeholder="bv. 1, 2, 3"
                  />
                </td>
                <td className="p-2">
                  <span
                    className="cursor-pointer underline text-nmi-dark"
                    title="Wysig hulpbronne"
                    onClick={() => openResourceModal(task)}
                  >
                    {getResourceNames(task.resources)}
                  </span>
                </td>
                <td className="p-2 text-center">
                  <input
                    type="checkbox"
                    checked={!!task.completed}
                    onChange={() =>
                      updateTask(task.id, "completed", !task.completed)
                    }
                    aria-label="Voltooi"
                  />
                </td>
                <td className="p-2 text-center">
                  <input
                    type="checkbox"
                    checked={!!task.busy}
                    onChange={() => updateTask(task.id, "busy", !task.busy)}
                    aria-label="Besig"
                  />
                </td>
                <td className="p-2">
                  <button
                    className="text-red-600 hover:text-red-800"
                    title="Delete"
                    onClick={() => deleteTask(task.id)}
                  >
                    🗑️
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        <div className="mt-4 flex justify-end">
          <button
            className="bg-nmi-dark text-white px-4 py-2 rounded hover:bg-nmi-accent"
            onClick={addTask}
            disabled={adding}
          >
            + Voeg taak by
          </button>
        </div>
      </div>
      {/* Modal for resource selection */}
      {modalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-30 flex items-center justify-center z-50">
          <div className="bg-white rounded shadow-lg p-6 min-w-[300px]">
            <h4 className="font-bold mb-2">Kies hulpbronne</h4>
            <div className="max-h-48 overflow-auto mb-4">
              <div className="mb-2 font-semibold">Groepe:</div>
              {groups.map((g) => (
                <label key={g.name} className="block text-sm mb-2">
                  <input
                    type="checkbox"
                    checked={modalSelected.includes(g.name)}
                    onChange={() => {
                      setModalSelected((prev) =>
                        prev.includes(g.name)
                          ? prev.filter((name) => name !== g.name)
                          : [...prev, g.name]
                      );
                    }}
                  />{" "}
                  {g.name}
                </label>
              ))}
              <div className="mt-2 font-semibold">Individuele hulpbronne:</div>
              {resources.map((r) => (
                <label key={r.name} className="block text-sm mb-1">
                  <input
                    type="checkbox"
                    checked={modalSelected.includes(r.name)}
                    onChange={() => {
                      setModalSelected((prev) =>
                        prev.includes(r.name)
                          ? prev.filter((name) => name !== r.name)
                          : [...prev, r.name]
                      );
                    }}
                  />{" "}
                  {r.name}
                </label>
              ))}
            </div>
            <div className="flex justify-end gap-2">
              <button
                className="px-3 py-1 rounded bg-gray-200"
                onClick={() => setModalOpen(false)}
              >
                Kanselleer
              </button>
              <button
                className="px-3 py-1 rounded bg-nmi-dark text-white"
                onClick={saveResourceModal}
              >
                Stoor
              </button>
            </div>
          </div>
        </div>
      )}
      <TaskFlowchart tasks={tasks} />
    </div>
  );
}
