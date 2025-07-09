import { useEffect, useState } from "react";
import Layout from "../components/Layout";

type CalendarEntry = {
  id: number;
  weekday: number;
  start_time: string;
  end_time: string;
};

const weekdayNames = ["Sondag", "Maandag", "Dinsdag", "Woensdag", "Donderdag", "Vrydag", "Saterdag"];

export default function Werksure() {
  const [calendar, setCalendar] = useState<CalendarEntry[]>([]);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editRow, setEditRow] = useState<Partial<CalendarEntry>>({});

  useEffect(() => {
    fetch("http://localhost:5000/api/calendar")
      .then(res => res.json())
      .then(setCalendar);
  }, []);

  const startEdit = (entry: CalendarEntry) => {
    setEditingId(entry.id);
    setEditRow({ ...entry });
  };

  const saveEdit = async () => {
    if (editingId == null) return;
    await fetch(`http://localhost:5000/api/calendar/${editingId}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(editRow),
    });
    setCalendar(c =>
      c.map(row => (row.id === editingId ? { ...row, ...editRow } as CalendarEntry : row))
    );
    setEditingId(null);
    setEditRow({});
  };

  return (
    <Layout>
      <h1 className="page-title">Werksure</h1>
      <div className="card">
        <table className="min-w-full">
          <thead>
            <tr>
              <th className="table-header">Weekdag</th>
              <th className="table-header">Begin Tyd</th>
              <th className="table-header">Eind Tyd</th>
              <th className="table-header">Aksie</th>
            </tr>
          </thead>
          <tbody>
            {calendar.map(entry =>
              editingId === entry.id ? (
                <tr key={entry.id}>
                  <td className="table-cell">
                    <select
                      value={editRow.weekday}
                      onChange={e => setEditRow(r => ({ ...r, weekday: Number(e.target.value) }))}
                    >
                      {weekdayNames.map((name, idx) => (
                        <option key={idx} value={idx}>{name}</option>
                      ))}
                    </select>
                  </td>
                  <td className="table-cell">
                    <input
                      type="time"
                      value={editRow.start_time}
                      onChange={e => setEditRow(r => ({ ...r, start_time: e.target.value }))}
                    />
                  </td>
                  <td className="table-cell">
                    <input
                      type="time"
                      value={editRow.end_time}
                      onChange={e => setEditRow(r => ({ ...r, end_time: e.target.value }))}
                    />
                  </td>
                  <td className="table-cell">
                    <button onClick={saveEdit} className="text-nmi-accent">Stoor</button>
                  </td>
                </tr>
              ) : (
                <tr key={entry.id}>
                  <td className="table-cell">{weekdayNames[entry.weekday]}</td>
                  <td className="table-cell">{entry.start_time}</td>
                  <td className="table-cell">{entry.end_time}</td>
                  <td className="table-cell">
                    <button onClick={() => startEdit(entry)} className="text-nmi-accent">Wysig</button>
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