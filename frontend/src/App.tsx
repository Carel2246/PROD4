import { BrowserRouter, Routes, Route } from "react-router-dom";
import Home from "./pages/Home";
import Werksure from "./pages/Werksure";
import Verlof from "./pages/Verlof";
import Hulpbronne from "./pages/Hulpbronne";
import Groepe from "./pages/Groepe";
import Produksieplanne from "./pages/Produksieplanne/Produksieplanne";
import VerslaeTaaklys from "./pages/Verslae/Taaklys";
import VerslaeSkedule from "./pages/Verslae/Skedule";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/werksure" element={<Werksure />} />
        <Route path="/verlof" element={<Verlof />} />
        <Route path="/hulpbronne" element={<Hulpbronne />} />
        <Route path="/groepe" element={<Groepe />} />
        <Route path="/produksieplanne" element={<Produksieplanne />} />
        <Route path="/verslae/taaklys" element={<VerslaeTaaklys />} />
        <Route path="/verslae/skedule" element={<VerslaeSkedule />} />
        {/* Add more routes here as new pages are created */}
      </Routes>
    </BrowserRouter>
  );
}

export default App;
