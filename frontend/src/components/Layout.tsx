import { useState } from "react";
import type { ReactNode } from "react";
import { Link } from "react-router-dom";

type LayoutProps = {
  children: ReactNode;
};

export default function Layout({ children }: LayoutProps) {
  const [menuOpen, setMenuOpen] = useState(false);
  const [setupOpen, setSetupOpen] = useState(false);

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
            <li>
              <Link
                to="/produksieplanne"
                className="text-nmi-dark hover:text-nmi-accent"
                onClick={() => setMenuOpen(false)}
              >
                Planne
              </Link>
            </li>
            <li>
              <button
                className="text-nmi-dark font-semibold w-full text-left focus:outline-none"
                onClick={() => setSetupOpen((open) => !open)}
              >
                Setup
              </button>
              {setupOpen && (
                <ul className="ml-4 mt-1 space-y-1 bg-white border-l-2 border-nmi-accent shadow-lg absolute left-44 top-0 p-2 min-w-[140px]">
                  <li>
                    <Link
                      to="/werksure"
                      className="text-nmi-dark hover:text-nmi-accent block"
                      onClick={() => {
                        setMenuOpen(false);
                        setSetupOpen(false);
                      }}
                    >
                      Werksure
                    </Link>
                  </li>
                  <li>
                    <Link
                      to="/verlof"
                      className="text-nmi-dark hover:text-nmi-accent block"
                      onClick={() => {
                        setMenuOpen(false);
                        setSetupOpen(false);
                      }}
                    >
                      Verlof
                    </Link>
                  </li>
                  <li>
                    <Link
                      to="/hulpbronne"
                      className="text-nmi-dark hover:text-nmi-accent block"
                      onClick={() => {
                        setMenuOpen(false);
                        setSetupOpen(false);
                      }}
                    >
                      Hulpbronne
                    </Link>
                  </li>
                  <li>
                    <Link
                      to="/groepe"
                      className="text-nmi-dark hover:text-nmi-accent block"
                      onClick={() => {
                        setMenuOpen(false);
                        setSetupOpen(false);
                      }}
                    >
                      Groepe
                    </Link>
                  </li>
                  {/* Add more setup items here */}
                </ul>
              )}
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
