import { useEffect, useState } from "react";

type Material = {
  id: number;
  name: string;
  quantity: number;
  unit: string;
  notes: string;
};

export default function MaterialTab({ jobNumber }: { jobNumber: string }) {
  const [materials, setMaterials] = useState<Material[]>([]);

  const fetchMaterials = () => {
    fetch(`/api/materials/by-job/${jobNumber}`)
      .then((res) => res.json())
      .then(setMaterials);
  };

  useEffect(() => {
    fetchMaterials();
  }, [jobNumber]);

  const updateMaterial = (
    id: number,
    field: keyof Material,
    value: string | number
  ) => {
    const updated = materials.map((m) =>
      m.id === id ? { ...m, [field]: value } : m
    );
    setMaterials(updated);

    fetch(`/api/materials/${id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ [field]: value }),
    }).catch(console.error);
  };

  return (
    <div className="card p-4 mt-4">
      <h3 className="text-nmi-dark font-bold mb-2">📦 Materiaal</h3>
      <div className="overflow-x-auto">
        <table className="min-w-full text-sm">
          <thead>
            <tr className="bg-nmi-dark text-nmi-accent">
              <th className="p-2">Naam</th>
              <th className="p-2">Hoeveelheid</th>
              <th className="p-2">Eenheid</th>
              <th className="p-2">Notas</th>
            </tr>
          </thead>
          <tbody>
            {materials.map((m) => (
              <tr key={m.id} className="border-t hover:bg-gray-50">
                <td className="p-2">
                  <input
                    className="form-input bg-nmi-light"
                    value={m.name}
                    onChange={(e) =>
                      updateMaterial(m.id, "name", e.target.value)
                    }
                  />
                </td>
                <td className="p-2">
                  <input
                    type="number"
                    className="form-input bg-nmi-light"
                    value={m.quantity}
                    onChange={(e) =>
                      updateMaterial(m.id, "quantity", Number(e.target.value))
                    }
                  />
                </td>
                <td className="p-2">
                  <input
                    className="form-input bg-nmi-light"
                    value={m.unit}
                    onChange={(e) =>
                      updateMaterial(m.id, "unit", e.target.value)
                    }
                  />
                </td>
                <td className="p-2">
                  <input
                    className="form-input bg-nmi-light"
                    value={m.notes}
                    onChange={(e) =>
                      updateMaterial(m.id, "notes", e.target.value)
                    }
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
