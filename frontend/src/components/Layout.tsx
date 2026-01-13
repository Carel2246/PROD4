import { useState } from "react";
import type { ReactNode } from "react";
import { Link } from "react-router-dom";

type LayoutProps = {
  children: ReactNode;
};

export default function Layout({ children }: LayoutProps) {
  const [menuOpen, setMenuOpen] = useState(false);
  const [setupOpen, setSetupOpen] = useState(false);
  const [verslaeOpen, setVerslaeOpen] = useState(false);
  const [planneOpen, setPlanneOpen] = useState(false);

  return (
    <div className="bg-page min-h-screen">
      {/* Page Header */}
      <header className="app-header flex justify-between items-center fixed top-0 left-0 w-full bg-white z-20 shadow">
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
        <nav
          className="bg-white shadow-md absolute z-30 w-48 p-4"
          style={{ top: "64px" }}
        >
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
            {/* Planne fly-out menu */}
            <li>
              <button
                className="text-nmi-dark font-semibold w-full text-left focus:outline-none"
                onClick={() => setPlanneOpen((open) => !open)}
              >
                Planne
              </button>
              {planneOpen && (
                <ul className="ml-4 mt-1 space-y-1 bg-white border-l-2 border-nmi-accent shadow-lg absolute left-44 top-0 p-2 min-w-[140px] z-40">
                  <li>
                    <Link
                      to="/produksieplanne"
                      className="text-nmi-dark hover:text-nmi-accent block"
                      onClick={() => {
                        setMenuOpen(false);
                        setPlanneOpen(false);
                      }}
                    >
                      Produksieplanne
                    </Link>
                  </li>
                  <li>
                    <Link
                      to="/plangeskiedenis"
                      className="text-nmi-dark hover:text-nmi-accent block"
                      onClick={() => {
                        setMenuOpen(false);
                        setPlanneOpen(false);
                      }}
                    >
                      Plangeskiedenis
                    </Link>
                  </li>
                </ul>
              )}
            </li>
            {/* Verslae fly-out menu */}
            <li>
              <button
                className="text-nmi-dark font-semibold w-full text-left focus:outline-none"
                onClick={() => setVerslaeOpen((open) => !open)}
              >
                Verslae
              </button>
              {verslaeOpen && (
                <ul className="ml-4 mt-1 space-y-1 bg-white border-l-2 border-nmi-accent shadow-lg absolute left-44 top-0 p-2 min-w-[140px] z-40">
                  <li>
                    <Link
                      to="/verslae/taaklys"
                      className="text-nmi-dark hover:text-nmi-accent block"
                      onClick={() => {
                        setMenuOpen(false);
                        setVerslaeOpen(false);
                      }}
                    >
                      Taaklys
                    </Link>
                  </li>
                  <li>
                    <Link
                      to="/verslae/skedule"
                      className="text-nmi-dark hover:text-nmi-accent block"
                      onClick={() => {
                        setMenuOpen(false);
                        setVerslaeOpen(false);
                      }}
                    >
                      Skedule
                    </Link>
                  </li>
                  {/* Add more Verslae pages here */}
                </ul>
              )}
            </li>
            {/* Setup fly-out menu */}
            <li>
              <button
                className="text-nmi-dark font-semibold w-full text-left focus:outline-none"
                onClick={() => setSetupOpen((open) => !open)}
              >
                Setup
              </button>
              {setupOpen && (
                <ul className="ml-4 mt-1 space-y-1 bg-white border-l-2 border-nmi-accent shadow-lg absolute left-44 top-0 p-2 min-w-[140px] z-40">
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

      <main className="pt-16 flex justify-center">
        <div className="w-full max-w-screen-lg px-2 sm:px-6 lg:px-8">
          {children}
        </div>
      </main>
    </div>
  );
}
