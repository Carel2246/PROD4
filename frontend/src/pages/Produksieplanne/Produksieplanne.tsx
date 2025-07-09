import { useEffect, useState } from "react";
import Layout from "../../components/Layout";
import TaskTab from "../Produksieplanne/TaskTab";
import MaterialTab from "../Produksieplanne/MaterialTab";

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
  const [newJobNumber, setNewJobNumber] = useState("");
  const [jobDetail, setJobDetail] = useState<JobDetail | null>(null);
  const [activeTab, setActiveTab] = useState<"tasks" | "materials">("tasks");

  // Fetch dropdown list of jobs
  const fetchJobs = () => {
    const query = `?includeCompleted=${includeCompleted}&includeBlocked=${includeBlocked}`;
    fetch(`http://localhost:5000/api/jobs/dropdown${query}`)
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
      fetch(`http://localhost:5000/api/jobs/${selectedJob}`)
        .then((res) => res.json())
        .then(setJobDetail)
        .catch(() => setJobDetail(null));
    }
  }, [selectedJob]);

  useEffect(() => {
    fetchJobs();
  }, [includeCompleted, includeBlocked]);

  const handleSelect = (jobNum: string) => {
    if (jobNum === "__create") {
      console.log("Create new job...");
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

    fetch(`http://localhost:5000/api/jobs/${selectedJob}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ [field]: value }),
    }).catch((err) => {
      console.error("Update failed:", err);
    });
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
                onClick={() => {
                  console.log("Dupliseer na:", newJobNumber);
                  setShowDuplicateModal(false);
                }}
              >
                Dupliseer
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
            <h2 className="text-lg font-semibold text-nmi-dark mb-4">
              PP Detail
            </h2>

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
                  value={
                    isNaN(jobDetail.price_each)
                      ? ""
                      : `R ${jobDetail.price_each.toFixed(2).replace(".", ",")}`
                  }
                  onChange={(e) => {
                    const value = parseFloat(
                      e.target.value.replace(/[^\d.]/g, "")
                    );
                    if (!isNaN(value)) updateField("price_each", value);
                  }}
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
              <TaskTab jobNumber={jobDetail.job_number} />
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
