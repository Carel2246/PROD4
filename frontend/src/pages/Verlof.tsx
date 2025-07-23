import { useEffect, useState, useRef } from "react";
import Layout from "../components/Layout";

type Holiday = {
  id: number;
  date: string;
  start_time: string | null;
  end_time: string | null;
  resources: any;
};

type Resource = {
  id: number;
  name: string;
};

const emptyNewHoliday = {
  date: "",
  start_time: "",
  end_time: "",
  resourceId: null as number | null,
  resourceName: "",
};

export default function Verlof() {
  const [holidays, setHolidays] = useState<Holiday[]>([]);
  const [resources, setResources] = useState<Resource[]>([]);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editRow, setEditRow] = useState<Partial<Holiday>>({});
  const [newHoliday, setNewHoliday] = useState({ ...emptyNewHoliday });
  const [resourceDropdownOpen, setResourceDropdownOpen] = useState(false);
  const resourceDropdownRef = useRef<HTMLDivElement>(null);

  // For measuring dropdown width
  const [dropdownWidth, setDropdownWidth] = useState<number>(0);
  const measureRef = useRef<HTMLSpanElement>(null);

  // Fetch holidays and resources
  useEffect(() => {
    fetch("/api/holidays")
      .then((res) => res.json())
      .then(setHolidays);

    fetch("/api/resources")
      .then((res) => res.json())
      .then(setResources);
  }, []);

  useEffect(() => {
    if (measureRef.current) {
      setDropdownWidth(measureRef.current.offsetWidth + 24); // 24px for padding
    }
  }, [resources]);

  // Close dropdown when clicking outside
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (
        resourceDropdownRef.current &&
        !resourceDropdownRef.current.contains(event.target as Node)
      ) {
        setResourceDropdownOpen(false);
      }
    }
    if (resourceDropdownOpen) {
      document.addEventListener("mousedown", handleClickOutside);
    } else {
      document.removeEventListener("mousedown", handleClickOutside);
    }
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [resourceDropdownOpen]);

  const handleAdd = async () => {
    if (!newHoliday.date || !newHoliday.resourceId) return;
    // Store as {"3": 1}
    const resourcesObj = { [newHoliday.resourceId]: 1 };
    const res = await fetch("/api/holidays", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        date: newHoliday.date,
        start_time: newHoliday.start_time,
        end_time: newHoliday.end_time,
        resources: resourcesObj,
      }),
    });
    const added = await res.json();
    setHolidays((h) => [...h, added]);
    setNewHoliday({ ...emptyNewHoliday });
  };

  const startEdit = (holiday: Holiday) => {
    setEditingId(holiday.id);
    setEditRow({
      start_time: holiday.start_time ?? "",
      end_time: holiday.end_time ?? "",
      resources: holiday.resources ? JSON.stringify(holiday.resources) : "",
    });
  };

  const saveEdit = async (id: number) => {
    await fetch(`/api/holidays/${id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        start_time: editRow.start_time,
        end_time: editRow.end_time,
        resources: editRow.resources
          ? JSON.parse(editRow.resources as string)
          : null,
      }),
    });
    setHolidays((h) =>
      h.map((row) =>
        row.id === id
          ? {
              ...row,
              start_time: editRow.start_time ?? null,
              end_time: editRow.end_time ?? null,
              resources: editRow.resources
                ? JSON.parse(editRow.resources as string)
                : null,
            }
          : row
      )
    );
    setEditingId(null);
    setEditRow({});
  };

  const handleDelete = async (id: number) => {
    await fetch(`/api/holidays/${id}`, {
      method: "DELETE",
    });
    setHolidays((h) => h.filter((row) => row.id !== id));
  };

  // Helper to format date as yyyy-mm-dd
  function formatDate(dateStr: string) {
    if (!dateStr) return "";
    const d = new Date(dateStr);
    if (isNaN(d.getTime())) return dateStr;
    return d.toISOString().slice(0, 10);
  }

  // Helper to get resource names from resources field
  function getResourceNames(resourcesField: any): string {
    if (!resourcesField) return "";
    if (Array.isArray(resourcesField)) {
      return resourcesField
        .map((id) => resources.find((r) => r.id === id)?.name)
        .filter(Boolean)
        .join(", ");
    }
    if (typeof resourcesField === "object") {
      return Object.keys(resourcesField)
        .map((key) => {
          const id = Number(key);
          return resources.find((r) => r.id === id)?.name;
        })
        .filter(Boolean)
        .join(", ");
    }
    return "";
  }

  return (
    <Layout>
      <h1 className="page-title">Verlof</h1>
      {/* Add Holiday Section */}
      <div className="mb-4">
        <div className="bg-white rounded shadow p-4 flex flex-col sm:flex-row gap-2 items-center">
          <div className="flex items-center gap-2 w-full sm:w-auto">
            <input
              type="date"
              value={newHoliday.date}
              onChange={(e) =>
                setNewHoliday((n) => ({ ...n, date: e.target.value }))
              }
              className="input input-bordered"
              placeholder="Datum"
            />
          </div>
          <div className="flex items-center gap-2 w-full sm:w-auto">
            <input
              type="time"
              value={newHoliday.start_time}
              onChange={(e) =>
                setNewHoliday((n) => ({ ...n, start_time: e.target.value }))
              }
              className="input input-bordered"
              placeholder="Begin tyd"
            />
          </div>
          <div className="flex items-center gap-2 w-full sm:w-auto">
            <input
              type="time"
              value={newHoliday.end_time}
              onChange={(e) =>
                setNewHoliday((n) => ({ ...n, end_time: e.target.value }))
              }
              className="input input-bordered"
              placeholder="Eind tyd"
            />
          </div>
          <div
            className="flex items-center gap-2 w-full sm:w-auto relative"
            ref={resourceDropdownRef}
          >
            <button
              type="button"
              className="input input-bordered flex-1 text-left"
              style={{ minWidth: dropdownWidth || 120 }}
              onClick={() => setResourceDropdownOpen((open) => !open)}
            >
              {newHoliday.resourceName || "Kies persoon"}
            </button>
            {/* Hidden span for measuring width */}
            <span
              ref={measureRef}
              className="absolute left-0 top-0 opacity-0 pointer-events-none whitespace-pre"
              style={{ fontWeight: 400, fontSize: "1rem", padding: "0 12px" }}
            >
              {resources.reduce(
                (longest, r) =>
                  r.name.length > longest.length ? r.name : longest,
                ""
              )}
            </span>
            {resourceDropdownOpen && (
              <ul
                className="absolute z-20 bg-white border border-gray-200 rounded shadow top-10 left-0 overflow-auto"
                style={{
                  minWidth: dropdownWidth || 120,
                  maxHeight: 6 * 40, // 6 items, 40px each
                }}
              >
                {resources.map((r) => (
                  <li
                    key={r.id}
                    className="px-3 py-2 hover:bg-nmi-accent hover:text-white cursor-pointer"
                    onClick={() => {
                      setNewHoliday((n) => ({
                        ...n,
                        resourceId: r.id,
                        resourceName: r.name,
                      }));
                      setResourceDropdownOpen(false);
                    }}
                  >
                    {r.name}
                  </li>
                ))}
              </ul>
            )}
          </div>
          <button
            onClick={handleAdd}
            className="px-4 py-2 border rounded border-nmi-accent text-nmi-accent bg-white hover:bg-nmi-accent hover:text-white transition"
          >
            Voeg by
          </button>
        </div>
      </div>
      {/* Holidays Table */}
      <div className="card">
        <table className="min-w-full">
          <thead>
            <tr>
              <th className="table-header">Datum</th>
              <th className="table-header">Begin tyd</th>
              <th className="table-header">Eind tyd</th>
              <th className="table-header">Persoon</th>
              <th className="table-header">Aksie</th>
            </tr>
          </thead>
          <tbody>
            {holidays.map((holiday) =>
              editingId === holiday.id ? (
                <tr key={holiday.id}>
                  <td className="table-cell">{formatDate(holiday.date)}</td>
                  <td className="table-cell">
                    <input
                      type="time"
                      value={editRow.start_time ?? ""}
                      onChange={(e) =>
                        setEditRow((r) => ({
                          ...r,
                          start_time: e.target.value,
                        }))
                      }
                    />
                  </td>
                  <td className="table-cell">
                    <input
                      type="time"
                      value={editRow.end_time ?? ""}
                      onChange={(e) =>
                        setEditRow((r) => ({ ...r, end_time: e.target.value }))
                      }
                    />
                  </td>
                  <td className="table-cell">
                    <input
                      type="text"
                      value={editRow.resources ?? ""}
                      onChange={(e) =>
                        setEditRow((r) => ({ ...r, resources: e.target.value }))
                      }
                      placeholder='{"3":1}'
                    />
                  </td>
                  <td className="table-cell">
                    <button
                      onClick={() => saveEdit(holiday.id)}
                      className="text-nmi-accent"
                    >
                      Stoor
                    </button>
                  </td>
                </tr>
              ) : (
                <tr key={holiday.id}>
                  <td className="table-cell">{formatDate(holiday.date)}</td>
                  <td className="table-cell">{holiday.start_time ?? ""}</td>
                  <td className="table-cell">{holiday.end_time ?? ""}</td>
                  <td className="table-cell">
                    {getResourceNames(holiday.resources)}
                  </td>
                  <td className="table-cell gap-2">
                    <button
                      onClick={() => startEdit(holiday)}
                      className="text-nmi-accent"
                    >
                      Wysig
                    </button>
                    <button
                      onClick={() => handleDelete(holiday.id)}
                      className="text-red-600"
                    >
                      Verwyder
                    </button>
                  </td>
                </tr>
              )
            )}
          </tbody>
        </table>
      </div>
    </Layout>
  );
}
