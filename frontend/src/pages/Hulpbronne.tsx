import React, { useEffect, useState } from "react";
import Layout from "../components/Layout";

type Resource = {
  id: number;
  name: string;
  type: "H" | "M";
};

const typeOptions = [
  { label: "Persoon", value: "H" },
  { label: "Masjien", value: "M" },
];

const emptyResource = {
  name: "",
  type: "H" as "H" | "M",
};

export default function Hulpbronne() {
  const [resources, setResources] = useState<Resource[]>([]);
  const [newResource, setNewResource] = useState({ ...emptyResource });
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editRow, setEditRow] = useState<Partial<Resource>>({});
  const [sortBy, setSortBy] = useState<"name" | "type">("name");
  const [sortDir, setSortDir] = useState<"asc" | "desc">("asc");
  const [groupByType, setGroupByType] = useState(false);

  useEffect(() => {
    fetch("http://localhost:5000/api/resources")
      .then((res) => res.json())
      .then(setResources);
  }, []);

  const handleAdd = async () => {
    if (!newResource.name) return;
    const res = await fetch("http://localhost:5000/api/resources", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(newResource),
    });
    const added = await res.json();
    setResources((r) => [...r, added]);
    setNewResource({ ...emptyResource });
  };

  const startEdit = (resource: Resource) => {
    setEditingId(resource.id);
    setEditRow({ name: resource.name, type: resource.type });
  };

  const saveEdit = async (id: number) => {
    await fetch(`http://localhost:5000/api/resources/${id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(editRow),
    });
    setResources((r) =>
      r.map((row) =>
        row.id === id
          ? {
              ...row,
              name: editRow.name ?? row.name,
              type: editRow.type ?? row.type,
            }
          : row
      )
    );
    setEditingId(null);
    setEditRow({});
  };

  const handleDelete = async (id: number) => {
    await fetch(`http://localhost:5000/api/resources/${id}`, {
      method: "DELETE",
    });
    setResources((r) => r.filter((row) => row.id !== id));
  };

  function typeLabel(type: string) {
    return type === "H" ? "Persoon" : type === "M" ? "Masjien" : type;
  }

  // Sorting logic
  function getSortedResources() {
    const sorted = [...resources].sort((a, b) => {
      let cmp = 0;
      if (sortBy === "name") {
        cmp = a.name.localeCompare(b.name);
      } else {
        cmp = typeLabel(a.type).localeCompare(typeLabel(b.type));
      }
      return sortDir === "asc" ? cmp : -cmp;
    });
    return sorted;
  }

  // Grouping logic
  function getGroupedResources() {
    const sorted = getSortedResources();
    const groups: { [key: string]: Resource[] } = {};
    sorted.forEach((r) => {
      const label = typeLabel(r.type);
      if (!groups[label]) groups[label] = [];
      groups[label].push(r);
    });
    return groups;
  }

  // Toggle sort
  function handleSort(col: "name" | "type") {
    if (sortBy === col) {
      setSortDir((d) => (d === "asc" ? "desc" : "asc"));
    } else {
      setSortBy(col);
      setSortDir("asc");
    }
  }

  return (
    <Layout>
      <h1 className="page-title">Hulpbronne</h1>
      {/* Add Resource Section */}
      <div className="mb-4">
        <div className="bg-white rounded shadow p-4 flex flex-col sm:flex-row gap-2 items-center">
          <input
            type="text"
            value={newResource.name}
            onChange={(e) =>
              setNewResource((n) => ({ ...n, name: e.target.value }))
            }
            className="input input-bordered"
            placeholder="Naam"
          />
          <select
            value={newResource.type}
            onChange={(e) =>
              setNewResource((n) => ({
                ...n,
                type: e.target.value as "H" | "M",
              }))
            }
            className="input input-bordered"
          >
            {typeOptions.map((opt) => (
              <option key={opt.value} value={opt.value}>
                {opt.label}
              </option>
            ))}
          </select>
          <button
            onClick={handleAdd}
            className="px-4 py-2 border rounded border-nmi-accent text-nmi-accent bg-white hover:bg-nmi-accent hover:text-white transition"
          >
            Voeg by
          </button>
        </div>
      </div>
      {/* Resources Table */}
      <div className="flex items-center mb-2">
        <label className="flex items-center gap-2">
          <input
            type="checkbox"
            checked={groupByType}
            onChange={() => setGroupByType((g) => !g)}
          />
          Groepeer volgens tipe
        </label>
      </div>
      <div className="card">
        <table className="min-w-full">
          <thead>
            <tr>
              <th
                className="table-header cursor-pointer select-none"
                onClick={() => handleSort("name")}
              >
                Naam {sortBy === "name" ? (sortDir === "asc" ? "▲" : "▼") : ""}
              </th>
              <th
                className="table-header cursor-pointer select-none"
                onClick={() => handleSort("type")}
              >
                Tipe {sortBy === "type" ? (sortDir === "asc" ? "▲" : "▼") : ""}
              </th>
              <th className="table-header">Aksie</th>
            </tr>
          </thead>
          <tbody>
            {groupByType
              ? Object.entries(getGroupedResources()).map(([group, items]) => (
                  <React.Fragment key={group}>
                    <tr>
                      <td
                        colSpan={3}
                        className="bg-gray-100 font-semibold pl-2"
                      >
                        {group}
                      </td>
                    </tr>
                    {items.map((resource) =>
                      editingId === resource.id ? (
                        <tr key={resource.id}>
                          <td className="table-cell">
                            <input
                              type="text"
                              value={editRow.name ?? ""}
                              onChange={(e) =>
                                setEditRow((r) => ({
                                  ...r,
                                  name: e.target.value,
                                }))
                              }
                            />
                          </td>
                          <td className="table-cell">
                            <select
                              value={editRow.type ?? "H"}
                              onChange={(e) =>
                                setEditRow((r) => ({
                                  ...r,
                                  type: e.target.value as "H" | "M",
                                }))
                              }
                            >
                              {typeOptions.map((opt) => (
                                <option key={opt.value} value={opt.value}>
                                  {opt.label}
                                </option>
                              ))}
                            </select>
                          </td>
                          <td className="table-cell">
                            <button
                              onClick={() => saveEdit(resource.id)}
                              className="text-nmi-accent"
                            >
                              Stoor
                            </button>
                          </td>
                        </tr>
                      ) : (
                        <tr key={resource.id}>
                          <td className="table-cell">{resource.name}</td>
                          <td className="table-cell">
                            {typeLabel(resource.type)}
                          </td>
                          <td className="table-cell gap-2">
                            <button
                              onClick={() => startEdit(resource)}
                              className="text-nmi-accent"
                            >
                              Wysig
                            </button>
                            <button
                              onClick={() => handleDelete(resource.id)}
                              className="text-red-600"
                            >
                              Verwyder
                            </button>
                          </td>
                        </tr>
                      )
                    )}
                  </React.Fragment>
                ))
              : getSortedResources().map((resource) =>
                  editingId === resource.id ? (
                    <tr key={resource.id}>
                      <td className="table-cell">
                        <input
                          type="text"
                          value={editRow.name ?? ""}
                          onChange={(e) =>
                            setEditRow((r) => ({
                              ...r,
                              name: e.target.value,
                            }))
                          }
                        />
                      </td>
                      <td className="table-cell">
                        <select
                          value={editRow.type ?? "H"}
                          onChange={(e) =>
                            setEditRow((r) => ({
                              ...r,
                              type: e.target.value as "H" | "M",
                            }))
                          }
                        >
                          {typeOptions.map((opt) => (
                            <option key={opt.value} value={opt.value}>
                              {opt.label}
                            </option>
                          ))}
                        </select>
                      </td>
                      <td className="table-cell">
                        <button
                          onClick={() => saveEdit(resource.id)}
                          className="text-nmi-accent"
                        >
                          Stoor
                        </button>
                      </td>
                    </tr>
                  ) : (
                    <tr key={resource.id}>
                      <td className="table-cell">{resource.name}</td>
                      <td className="table-cell">{typeLabel(resource.type)}</td>
                      <td className="table-cell gap-2">
                        <button
                          onClick={() => startEdit(resource)}
                          className="text-nmi-accent"
                        >
                          Wysig
                        </button>
                        <button
                          onClick={() => handleDelete(resource.id)}
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
