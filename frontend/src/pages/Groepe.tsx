import { useEffect, useState } from "react";
import Layout from "../components/Layout";

type Resource = { id: number; name: string; type: "H" | "M" };
type Group = {
  id: number;
  name: string;
  type: "H" | "M";
  resources: Resource[];
};

const typeOptions = [
  { label: "Persone", value: "H" },
  { label: "Masjiene", value: "M" },
];

const emptyGroup = {
  name: "",
  type: "H" as "H" | "M",
  resourceIds: [] as number[],
};

export default function Groepe() {
  const [groups, setGroups] = useState<Group[]>([]);
  const [resources, setResources] = useState<Resource[]>([]);
  const [newGroup, setNewGroup] = useState({ ...emptyGroup });
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editRow, setEditRow] = useState<
    Partial<Group> & { resourceIds?: number[] }
  >({});
  const [sortBy, setSortBy] = useState<"name" | "type">("name");
  const [sortDir, setSortDir] = useState<"asc" | "desc">("asc");

  useEffect(() => {
    fetch("http://localhost:5000/api/resource-groups")
      .then((res) => res.json())
      .then(setGroups);
    fetch("http://localhost:5000/api/resources")
      .then((res) => res.json())
      .then(setResources);
  }, []);

  const handleAdd = async () => {
    if (!newGroup.name) return;
    const res = await fetch("http://localhost:5000/api/resource-groups", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        name: newGroup.name,
        type: newGroup.type,
        resourceIds: newGroup.resourceIds,
      }),
    });
    const added = await res.json();
    setGroups((g) => [
      ...g,
      {
        ...added,
        resources: resources.filter((r) => newGroup.resourceIds.includes(r.id)),
      },
    ]);
    setNewGroup({ ...emptyGroup });
  };

  const startEdit = (group: Group) => {
    setEditingId(group.id);
    setEditRow({
      name: group.name,
      type: group.type,
      resourceIds: group.resources.map((r) => r.id),
    });
  };

  const saveEdit = async (id: number) => {
    await fetch(`http://localhost:5000/api/resource-groups/${id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        name: editRow.name,
        type: editRow.type,
        resourceIds: editRow.resourceIds,
      }),
    });
    setGroups((g) =>
      g.map((row) =>
        row.id === id
          ? {
              ...row,
              name: editRow.name ?? row.name,
              type: editRow.type ?? row.type,
              resources: resources.filter((r) =>
                editRow.resourceIds?.includes(r.id)
              ),
            }
          : row
      )
    );
    setEditingId(null);
    setEditRow({});
  };

  const handleDelete = async (id: number) => {
    await fetch(`http://localhost:5000/api/resource-groups/${id}`, {
      method: "DELETE",
    });
    setGroups((g) => g.filter((row) => row.id !== id));
  };

  function typeLabel(type: string) {
    return type === "H" ? "Persone" : type === "M" ? "Masjiene" : type;
  }

  function getSortedGroups() {
    const sorted = [...groups].sort((a, b) => {
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

  function handleSort(col: "name" | "type") {
    if (sortBy === col) {
      setSortDir((d) => (d === "asc" ? "desc" : "asc"));
    } else {
      setSortBy(col);
      setSortDir("asc");
    }
  }

  // Filter resources by type for dropdown
  const filteredResources = resources.filter(
    (r) => r.type === (editingId ? editRow.type : newGroup.type)
  );

  return (
    <Layout>
      <h1 className="page-title">Groepe</h1>
      {/* Add Group Section */}
      <div className="mb-4">
        <div className="bg-white rounded shadow p-4 flex flex-col sm:flex-row gap-2 items-center">
          <input
            type="text"
            value={newGroup.name}
            onChange={(e) =>
              setNewGroup((n) => ({ ...n, name: e.target.value }))
            }
            className="input input-bordered"
            placeholder="Naam"
          />
          <select
            value={newGroup.type}
            onChange={(e) =>
              setNewGroup((n) => ({
                ...n,
                type: e.target.value as "H" | "M",
                resourceIds: [],
              }))
            }
            className="input input-bordered"
            style={{ marginLeft: "5vw" }}
          >
            {typeOptions.map((opt) => (
              <option key={opt.value} value={opt.value}>
                {opt.label}
              </option>
            ))}
          </select>
          <select
            multiple
            value={newGroup.resourceIds.map(String)}
            onChange={(e) =>
              setNewGroup((n) => ({
                ...n,
                resourceIds: Array.from(e.target.selectedOptions, (opt) =>
                  Number(opt.value)
                ),
              }))
            }
            className="input input-bordered"
            style={{ minWidth: 120, maxHeight: 120, marginLeft: "5vw" }}
          >
            {filteredResources.map((r) => (
              <option key={r.id} value={r.id}>
                {r.name}
              </option>
            ))}
          </select>
          <button
            onClick={handleAdd}
            className="px-4 py-2 border rounded border-nmi-accent text-nmi-accent bg-white hover:bg-nmi-accent hover:text-white transition"
            style={{ marginLeft: "5vw" }}
          >
            Voeg by
          </button>
        </div>
      </div>
      {/* Groups Table */}
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
              <th className="table-header">Resources</th>
              <th className="table-header">Aksie</th>
            </tr>
          </thead>
          <tbody>
            {getSortedGroups().map((group) =>
              editingId === group.id ? (
                <tr key={group.id}>
                  <td className="table-cell">
                    <input
                      type="text"
                      value={editRow.name ?? ""}
                      onChange={(e) =>
                        setEditRow((r) => ({ ...r, name: e.target.value }))
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
                          resourceIds: [],
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
                    <select
                      multiple
                      value={editRow.resourceIds?.map(String) ?? []}
                      onChange={(e) =>
                        setEditRow((r) => ({
                          ...r,
                          resourceIds: Array.from(
                            e.target.selectedOptions,
                            (opt) => Number(opt.value)
                          ),
                        }))
                      }
                      className="input input-bordered"
                      style={{ minWidth: 120, maxHeight: 120 }}
                    >
                      {resources
                        .filter((r) => r.type === (editRow.type ?? group.type))
                        .map((r) => (
                          <option key={r.id} value={r.id}>
                            {r.name}
                          </option>
                        ))}
                    </select>
                  </td>
                  <td className="table-cell">
                    <button
                      onClick={() => saveEdit(group.id)}
                      className="text-nmi-accent"
                    >
                      Stoor
                    </button>
                  </td>
                </tr>
              ) : (
                <tr key={group.id}>
                  <td className="table-cell">{group.name}</td>
                  <td className="table-cell">{typeLabel(group.type)}</td>
                  <td className="table-cell">
                    {group.resources.map((r) => r.name).join(", ")}
                  </td>
                  <td className="table-cell gap-2">
                    <button
                      onClick={() => startEdit(group)}
                      className="text-nmi-accent"
                    >
                      Wysig
                    </button>
                    <button
                      onClick={() => handleDelete(group.id)}
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
