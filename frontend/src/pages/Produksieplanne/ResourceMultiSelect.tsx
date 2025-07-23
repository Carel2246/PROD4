import { useEffect, useState } from "react";

type Resource = {
  id: number;
  name: string;
  type: string;
};

export default function ResourceMultiSelect({
  selected,
  onChange,
  type,
}: {
  selected: number[];
  onChange: (newIds: number[]) => void;
  type: "resource" | "group" | "all";
}) {
  const [options, setOptions] = useState<Resource[]>([]);

  useEffect(() => {
    fetch("/api/resources")
      .then((res) => res.json())
      .then((data) =>
        setOptions(
          data.filter((r: Resource) =>
            type === "all"
              ? true
              : type === "resource"
              ? r.type === "machine" || r.type === "operator"
              : r.type === "group"
          )
        )
      );
  }, [type]);

  const toggle = (id: number) => {
    if (selected.includes(id)) {
      onChange(selected.filter((i) => i !== id));
    } else {
      onChange([...selected, id]);
    }
  };

  return (
    <div className="bg-nmi-light border rounded px-2 py-1 max-h-32 overflow-auto">
      {options.map((opt) => (
        <label key={opt.id} className="block text-xs">
          <input
            type="checkbox"
            className="mr-1"
            checked={selected.includes(opt.id)}
            onChange={() => toggle(opt.id)}
          />
          {opt.name}
        </label>
      ))}
    </div>
  );
}
