import { useEffect, useState } from "react";
import Layout from "../../components/Layout";
import TaskTab from "../Produksieplanne/TaskTab";
import MaterialTab from "../Produksieplanne/MaterialTab";
import { useLocation, useNavigate } from "react-router-dom";

type JobDropdownItem = {
  job_number: string;
  description: string;
};

type JobDetail = {
  job_number: string;
  description: string;
  order_date: string;
  promised_date: string;
  quantity: number;
  price_each: number;
  customer: string;
  completed: boolean;
  blocked: boolean;
};

export default function Produksieplanne() {
  const [jobs, setJobs] = useState<JobDropdownItem[]>([]);
  const [includeCompleted, setIncludeCompleted] = useState(false);
  const [includeBlocked, setIncludeBlocked] = useState(false);
  const [selectedJob, setSelectedJob] = useState<string | null>(null);
  const [showDuplicateModal, setShowDuplicateModal] = useState(false);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [newJobNumber, setNewJobNumber] = useState("");
  const [creatingJob, setCreatingJob] = useState(false);
  const [jobDetail, setJobDetail] = useState<JobDetail | null>(null);
  const [activeTab, setActiveTab] = useState<"tasks" | "materials">("tasks");
  const [refreshTasksFlag, setRefreshTasksFlag] = useState(false);
  const [priceEachInput, setPriceEachInput] = useState<string>("");
  const [validationStatus, setValidationStatus] = useState<"ok" | null>(null);

  const location = useLocation();
  const navigate = useNavigate();

  // Fetch dropdown list of jobs
  const fetchJobs = () => {
    const query = `?includeCompleted=${includeCompleted}&includeBlocked=${includeBlocked}`;
    fetch(`/api/jobs/dropdown${query}`)
      .then((res) => res.json())
      .then((data) => {
        // Sort by job_number ascending
        const sorted = data.sort((a: JobDropdownItem, b: JobDropdownItem) =>
          a.job_number.localeCompare(b.job_number, undefined, { numeric: true })
        );
        setJobs(sorted);
      })
      .catch((err) => console.error("Dropdown fetch failed", err));
  };

  // Fetch selected job detail
  useEffect(() => {
    if (
      selectedJob &&
      selectedJob !== "__create" &&
      selectedJob !== "__duplicate"
    ) {
      fetch(`/api/jobs/${selectedJob}`)
        .then((res) => res.json())
        .then(setJobDetail)
        .catch(() => setJobDetail(null));
    }
  }, [selectedJob]);

  useEffect(() => {
    fetchJobs();
  }, [includeCompleted, includeBlocked]);

  useEffect(() => {
    if (location.state?.selectedJob) {
      setSelectedJob(location.state.selectedJob);
    }
  }, [location.state]);

  useEffect(() => {
    // Reset validation status when job changes
    setValidationStatus(null);
  }, [selectedJob]);

  useEffect(() => {
    setPriceEachInput(
      jobDetail && !isNaN(jobDetail.price_each)
        ? jobDetail.price_each.toString().replace(".", ",")
        : ""
    );
  }, [jobDetail]);

  const handleSelect = (jobNum: string) => {
    if (jobNum === "__create") {
      setShowCreateModal(true);
    } else if (jobNum === "__duplicate") {
      setShowDuplicateModal(true);
    } else {
      setSelectedJob(jobNum);
    }
  };

  const updateField = (field: keyof JobDetail, value: any) => {
    if (!selectedJob || !jobDetail) return;

    const updated = { ...jobDetail, [field]: value };
    setJobDetail(updated);
    setValidationStatus(null); // Reset validation status on data change

    fetch(`/api/jobs/${selectedJob}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ [field]: value }),
    })
      .then(() => {
        // If the completed field was changed, update all tasks for this job
        if (field === "completed") {
          fetch(`/api/tasks/by-job/${selectedJob}`)
            .then((res) => res.json())
            .then((tasks) => {
              Promise.all(
                tasks.map((task: any) =>
                  fetch(`/api/tasks/${task.id}`, {
                    method: "PATCH",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ completed: value }),
                  })
                )
              ).then(() => {
                setRefreshTasksFlag((f) => !f); // <-- trigger TaskTab refresh
                refetchJobDetail();
              });
            });
        }
      })
      .catch((err) => {
        console.error("Update failed:", err);
      });
  };

  const refetchJobDetail = () => {
    if (selectedJob) {
      fetch(`/api/jobs/${selectedJob}`)
        .then((res) => res.json())
        .then(setJobDetail)
        .catch(() => setJobDetail(null));
    }
  };

  const handleValidateData = () => {
    if (!jobDetail) return;

    fetch(`/api/tasks/by-job/${jobDetail.job_number}`)
      .then((res) => res.json())
      .then((tasks) => {
        Promise.all([
          fetch("/api/resources").then((r) => r.json()),
          fetch("/api/resource-groups").then((r) => r.json()),
        ])
          .then(([resources, groups]) => {
            const resourceNames = new Set(resources.map((r: any) => r.name));
            const groupNames = new Set(groups.map((g: any) => g.name));

            let issues = [];
            for (const task of tasks) {
              // Check for self-reference in predecessors
              if (task.predecessors) {
                const preds = task.predecessors
                  .split(",")
                  .map((p: string) => p.trim());
                if (preds.includes(task.task_number)) {
                  issues.push({ task, type: "circular" });
                }
              }
              // Check invalid resources
              if (task.resources) {
                const resList = task.resources
                  .split(",")
                  .map((r: string) => r.trim());
                for (const res of resList) {
                  if (!resourceNames.has(res) && !groupNames.has(res)) {
                    issues.push({
                      task,
                      type: "invalid_resource",
                      resource: res,
                    });
                  }
                }
              }
            }

            if (issues.length === 0) {
              setValidationStatus("ok");
            } else {
              // Navigate to TaskEdit for the first issue
              const firstIssue = issues[0];
              navigate(
                `/taskedit?taskId=${firstIssue.task.id}&issue=${firstIssue.type}`
              );
              setValidationStatus(null);
            }
          })
          .catch((err) => console.error("Validation fetch failed:", err));
      })
      .catch((err) => console.error("Tasks fetch failed:", err));
  };

  return (
    <Layout>
      <h1 className="page-title">Produksieplanne</h1>

      {/* === JOB SELECTOR === */}
      <div className="mb-6 flex flex-col sm:flex-row sm:items-center gap-4">
        <div className="flex flex-col">
          <label className="text-sm font-semibold text-nmi-dark">
            PP Nommer
          </label>
          <select
            className="border border-gray-300 rounded p-2 bg-white w-64"
            value={selectedJob || ""}
            onChange={(e) => handleSelect(e.target.value)}
          >
            <option value="">-- Kies werksplan --</option>
            <option value="__create">➕ Voeg nuwe plan by</option>
            <option value="__duplicate">📄 Dupliseer plan</option>
            {jobs.map((job) => (
              <option key={job.job_number} value={job.job_number}>
                {job.job_number} – {job.description}
              </option>
            ))}
          </select>
        </div>

        <div className="flex flex-col gap-2">
          <label className="text-sm font-medium text-nmi-dark">
            <input
              type="checkbox"
              className="mr-2"
              checked={includeCompleted}
              onChange={() => setIncludeCompleted(!includeCompleted)}
            />
            Sluit Voltooide In
          </label>

          <label className="text-sm font-medium text-nmi-dark">
            <input
              type="checkbox"
              className="mr-2"
              checked={includeBlocked}
              onChange={() => setIncludeBlocked(!includeBlocked)}
            />
            Sluit Geblokkeerde In
          </label>
        </div>
      </div>

      {/* === DUPLICATE MODAL === */}
      {showDuplicateModal && (
        <div className="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50">
          <div className="bg-white rounded shadow p-6 w-96">
            <h2 className="text-lg font-bold mb-4">Dupliseer Plan</h2>
            <label className="block mb-2 text-sm">Nuwe PP Nommer:</label>
            <input
              type="text"
              className="border border-gray-300 rounded w-full p-2 mb-4"
              value={newJobNumber}
              onChange={(e) => setNewJobNumber(e.target.value)}
            />
            <div className="flex justify-end gap-3">
              <button
                className="px-4 py-2 bg-nmi-light text-nmi-dark border rounded"
                onClick={() => setShowDuplicateModal(false)}
              >
                Kanselleer
              </button>
              <button
                className="px-4 py-2 bg-nmi-accent text-white rounded"
                onClick={async () => {
                  setCreatingJob(true);
                  const res = await fetch("/api/jobs/duplicate", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({
                      source_job_number: selectedJob,
                      new_job_number: newJobNumber,
                    }),
                  });
                  if (res.ok) {
                    setShowDuplicateModal(false);
                    setSelectedJob(newJobNumber);
                    setNewJobNumber("");
                    fetchJobs();
                  } else {
                    alert("Kon nie dupliseer nie.");
                  }
                  setCreatingJob(false);
                }}
                disabled={!newJobNumber || creatingJob}
              >
                Dupliseer
              </button>
            </div>
          </div>
        </div>
      )}

      {/* === CREATE MODAL === */}
      {showCreateModal && (
        <div className="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50">
          <div className="bg-white rounded shadow p-6 w-96">
            <h2 className="text-lg font-bold mb-4">Voeg nuwe plan by</h2>
            <label className="block mb-2 text-sm">PP Nommer:</label>
            <input
              type="text"
              className="border border-gray-300 rounded w-full p-2 mb-4"
              value={newJobNumber}
              onChange={(e) => setNewJobNumber(e.target.value)}
              disabled={creatingJob}
            />
            <div className="flex justify-end gap-3">
              <button
                className="px-4 py-2 bg-nmi-light text-nmi-dark border rounded"
                onClick={() => setShowCreateModal(false)}
                disabled={creatingJob}
              >
                Kanselleer
              </button>
              <button
                className="px-4 py-2 bg-nmi-accent text-white rounded"
                onClick={async () => {
                  setCreatingJob(true);
                  // Create the job in the backend
                  const res = await fetch("/api/jobs", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ job_number: newJobNumber }),
                  });
                  if (res.ok) {
                    setShowCreateModal(false);
                    setSelectedJob(newJobNumber);
                    setNewJobNumber("");
                    fetchJobs();
                  } else {
                    alert("Kon nie nuwe plan skep nie.");
                  }
                  setCreatingJob(false);
                }}
                disabled={!newJobNumber || creatingJob}
              >
                Skep
              </button>
            </div>
          </div>
        </div>
      )}

      {/* === JOB DETAILS FORM === */}
      {selectedJob &&
        selectedJob !== "__duplicate" &&
        selectedJob !== "__create" &&
        jobDetail && (
          <div className="mt-8 card p-4">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-lg font-semibold text-nmi-dark">PP Detail</h2>
              <div className="flex items-center gap-2">
                <button
                  className="px-4 py-2 bg-blue-500 text-white rounded"
                  onClick={handleValidateData}
                >
                  Gaan data na
                </button>
                {validationStatus === "ok" && (
                  <span className="text-green-500 font-semibold">Data OK</span>
                )}
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              <FormRow label="PP Nommer">
                <input
                  className="form-input bg-nmi-light"
                  value={jobDetail.job_number}
                  onChange={(e) =>
                    setJobDetail({ ...jobDetail, job_number: e.target.value })
                  }
                  onBlur={() => updateField("job_number", jobDetail.job_number)}
                />
              </FormRow>

              <FormRow label="Beskrywing">
                <input
                  className="form-input bg-nmi-light"
                  value={jobDetail.description}
                  onChange={(e) => updateField("description", e.target.value)}
                />
              </FormRow>

              <FormRow label="Kliënt">
                <input
                  className="form-input bg-nmi-light"
                  value={jobDetail.customer || ""}
                  onChange={(e) => updateField("customer", e.target.value)}
                />
              </FormRow>

              <FormRow label="Besteldatum">
                <input
                  type="date"
                  className="form-input bg-nmi-light"
                  value={jobDetail.order_date?.slice(0, 10) || ""}
                  onChange={(e) => updateField("order_date", e.target.value)}
                />
              </FormRow>

              <FormRow label="Beloofdatum">
                <input
                  type="date"
                  className="form-input bg-nmi-light"
                  value={jobDetail.promised_date?.slice(0, 10) || ""}
                  onChange={(e) => updateField("promised_date", e.target.value)}
                />
              </FormRow>

              <FormRow label="Hoeveelheid">
                <input
                  type="number"
                  className="form-input bg-nmi-light"
                  value={jobDetail.quantity}
                  onChange={(e) =>
                    updateField("quantity", Number(e.target.value))
                  }
                />
              </FormRow>

              <FormRow label="Prys elk">
                <input
                  type="text"
                  className="form-input bg-nmi-light"
                  value={priceEachInput}
                  onChange={(e) => {
                    setPriceEachInput(e.target.value);
                  }}
                  onBlur={() => {
                    // Replace comma with dot for decimal
                    const val = priceEachInput.replace(",", ".");
                    const num = parseFloat(val);
                    if (!isNaN(num)) {
                      updateField("price_each", num);
                    } else if (priceEachInput.trim() === "") {
                      updateField("price_each", 0); // Or null if you prefer
                    }
                  }}
                  onKeyDown={(e) => {
                    if (e.key === "Enter") {
                      e.currentTarget.blur();
                    }
                  }}
                  placeholder="R 0,00"
                />
              </FormRow>

              <FormRow label="Voltooi">
                <input
                  type="checkbox"
                  className="h-5 w-5"
                  checked={jobDetail.completed}
                  onChange={(e) => updateField("completed", e.target.checked)}
                />
              </FormRow>

              <FormRow label="Geblok">
                <input
                  type="checkbox"
                  className="h-5 w-5"
                  checked={jobDetail.blocked}
                  onChange={(e) => updateField("blocked", e.target.checked)}
                />
              </FormRow>
            </div>
            <div className="mt-6 border-b border-gray-300 pb-2 flex gap-4">
              <button
                className={`px-4 py-2 rounded-t ${
                  activeTab === "tasks"
                    ? "bg-nmi-dark text-white"
                    : "bg-gray-100"
                }`}
                onClick={() => setActiveTab("tasks")}
              >
                🛠️ Take
              </button>
              <button
                className={`px-4 py-2 rounded-t ${
                  activeTab === "materials"
                    ? "bg-nmi-dark text-white"
                    : "bg-gray-100"
                }`}
                onClick={() => setActiveTab("materials")}
              >
                📦 Materiaal
              </button>
            </div>
            {activeTab === "tasks" && (
              <TaskTab
                jobNumber={jobDetail.job_number}
                onJobStatusChange={refetchJobDetail}
                refreshTasksTrigger={refreshTasksFlag}
              />
            )}
            {activeTab === "materials" && (
              <MaterialTab jobNumber={jobDetail.job_number} />
            )}
          </div>
        )}
    </Layout>
  );
}

// === Helper component ===
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
