import { useEffect, useState } from "react";
import Layout from "../components/Layout";

type Job = {
  job_number: string;
  description: string;
  promised_date: string;
  quantity: number;
  customer: string;
};

export default function Home() {
  const [jobs, setJobs] = useState<Job[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetch("/api/jobs/incomplete")
      .then((res) => {
        if (!res.ok) throw new Error("Network response was not ok");
        return res.json();
      })
      .then((data) => {
        setJobs(data);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Failed to fetch jobs:", err);
        setError("Kon nie werksopdragte laai nie.");
        setLoading(false);
      });
  }, []);

  return (
    <Layout>
      <h1 className="page-title">Onvoltooide Werksopdragte</h1>

      {loading && <p>Laai data...</p>}
      {error && <p className="text-red-600">{error}</p>}

      {!loading && !error && (
        <div className="card">
          <table className="min-w-full">
            <thead>
              <tr>
                <th className="table-header">Job Nommer</th>
                <th className="table-header">Beskrywing</th>
                <th className="table-header">Datum</th>
                <th className="table-header">Hoeveelheid</th>
                <th className="table-header">Kliënt</th>
              </tr>
            </thead>
            <tbody>
              {jobs.map((job) => (
                <tr key={job.job_number} className="hover:bg-gray-50">
                  <td className="table-cell font-mono">{job.job_number}</td>
                  <td className="table-cell">{job.description}</td>
                  <td className="table-cell">
                    {new Date(job.promised_date).toLocaleDateString("af-ZA")}
                  </td>
                  <td className="table-cell">{job.quantity}</td>
                  <td className="table-cell">{job.customer}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </Layout>
  );
}
