import { useState } from "react";
import type { ReactNode } from "react";
import { Link } from "react-router-dom";

type LayoutProps = {
  children: ReactNode;
};

export default function Layout({ children }: LayoutProps) {
  const [menuOpen, setMenuOpen] = useState(false);

  return (
    <div className="bg-page min-h-screen">
      {/* Page Header */}
      <header className="app-header flex justify-between items-center">
        <div className="flex items-center gap-3">
          <button
            onClick={() => setMenuOpen(!menuOpen)}
            className="text-nmi-accent text-2xl focus:outline-none"
          >
            ☰
          </button>
          <span className="text-nmi-accent text-lg font-bold">
            NMI Produksie
          </span>
        </div>
      </header>

      {/* Navigation Drawer */}
      {menuOpen && (
        <nav className="bg-white shadow-md absolute z-10 w-48 p-4">
          <ul className="space-y-2">
            <li>
              <Link
                to="/"
                className="text-nmi-dark hover:text-nmi-accent"
                onClick={() => setMenuOpen(false)}
              >
                Tuisblad
              </Link>
            </li>
            {/* Add more nav items here */}
          </ul>
        </nav>
      )}

      <main className="pt-4 flex justify-center">
        <div className="w-full max-w-screen-lg px-2 sm:px-6 lg:px-8">
          {children}
        </div>
      </main>
    </div>
  );
}
