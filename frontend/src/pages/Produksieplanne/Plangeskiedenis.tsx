import { useEffect, useState } from "react";
import Layout from "../../components/Layout";

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

export default function Plangeskiedenis() {
  const [jobs, setJobs] = useState<JobDetail[]>([]);
  const [includeCompleted, setIncludeCompleted] = useState(false);
  const [includeBlocked, setIncludeBlocked] = useState(false);
  const [sortColumn, setSortColumn] = useState<string>("job_number");
  const [sortDirection, setSortDirection] = useState<"asc" | "desc">("asc");
  const [filters, setFilters] = useState<{ [key: string]: string }>({});

  const fetchJobs = () => {
    fetch("/api/jobs")
      .then((res) => res.json())
      .then(setJobs)
      .catch((err) => console.error("Failed to fetch jobs:", err));
  };

  useEffect(() => {
    fetchJobs();
  }, []);

  const filteredJobs = jobs
    .filter((job) => {
      if (!includeCompleted && job.completed) return false;
      if (!includeBlocked && job.blocked) return false;
      return true;
    })
    .filter((job) => {
      for (const col in filters) {
        const val = filters[col].toLowerCase();
        if (val) {
          if (col === "total_price") {
            const total = (job.price_each * job.quantity).toFixed(2);
            if (!total.includes(val)) return false;
          } else {
            if (
              !String(job[col as keyof JobDetail])
                .toLowerCase()
                .includes(val)
            )
              return false;
          }
        }
      }
      return true;
    });

  const sortedJobs = [...filteredJobs].sort((a, b) => {
    let aVal: any = a[sortColumn as keyof JobDetail];
    let bVal: any = b[sortColumn as keyof JobDetail];

    if (sortColumn === "order_date" || sortColumn === "promised_date") {
      aVal = new Date(aVal);
      bVal = new Date(bVal);
    } else if (sortColumn === "quantity" || sortColumn === "price_each") {
      aVal = Number(aVal);
      bVal = Number(bVal);
    } else if (sortColumn === "job_number") {
      const aNum = parseFloat(aVal);
      const bNum = parseFloat(bVal);
      if (!isNaN(aNum) && !isNaN(bNum)) {
        aVal = aNum;
        bVal = bNum;
      }
    } else if (sortColumn === "total_price") {
      aVal = a.price_each * a.quantity;
      bVal = b.price_each * b.quantity;
    }

    if (aVal < bVal) return sortDirection === "asc" ? -1 : 1;
    if (aVal > bVal) return sortDirection === "asc" ? 1 : -1;
    return 0;
  });

  const handleSort = (col: string) => {
    if (sortColumn === col) {
      setSortDirection(sortDirection === "asc" ? "desc" : "asc");
    } else {
      setSortColumn(col);
      setSortDirection("asc");
    }
  };

  const handleFilterChange = (col: string, val: string) => {
    setFilters((prev) => ({ ...prev, [col]: val }));
  };

  const columnLabels: { [key: string]: string } = {
    job_number: "PP Nommer",
    customer: "Kliënt",
    description: "Beskrywing",
    order_date: "Besteldatum",
    promised_date: "Beloofdatum",
    quantity: "Hoeveelheid",
    total_price: "Totale prys",
  };

  const columns = [
    "job_number",
    "customer",
    "description",
    "order_date",
    "promised_date",
    "quantity",
    "total_price",
  ];

  return (
    <Layout>
      <h1 className="page-title">Plangeskiedenis</h1>

      <div className="mb-4 flex gap-4">
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

      <div className="overflow-x-auto">
        <table className="w-full border-collapse border border-gray-300 text-sm">
          <thead>
            <tr>
              {columns.map((col) => (
                <th
                  key={col}
                  className="border border-gray-300 p-2 bg-gray-100 cursor-pointer select-none"
                  onClick={() => handleSort(col)}
                >
                  {columnLabels[col]}
                  {sortColumn === col &&
                    (sortDirection === "asc" ? " ↑" : " ↓")}
                </th>
              ))}
            </tr>
            <tr>
              {columns.map((col) => (
                <th key={col} className="border border-gray-300 p-2">
                  <input
                    type="text"
                    placeholder={`Filter ${columnLabels[col]}`}
                    value={filters[col] || ""}
                    onChange={(e) => handleFilterChange(col, e.target.value)}
                    className="w-full p-1 border border-gray-300 text-xs"
                  />
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {sortedJobs.map((job) => (
              <tr key={job.job_number} className="hover:bg-gray-50">
                <td className="border border-gray-300 p-2">{job.job_number}</td>
                <td className="border border-gray-300 p-2">
                  {job.customer || ""}
                </td>
                <td className="border border-gray-300 p-2">
                  {job.description}
                </td>
                <td className="border border-gray-300 p-2">
                  {new Date(job.order_date).toLocaleDateString("af-ZA")}
                </td>
                <td className="border border-gray-300 p-2">
                  {new Date(job.promised_date).toLocaleDateString("af-ZA")}
                </td>
                <td className="border border-gray-300 p-2">{job.quantity}</td>
                <td className="border border-gray-300 p-2">
                  R{" "}
                  {(job.price_each * job.quantity).toFixed(2).replace(".", ",")}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </Layout>
  );
}
