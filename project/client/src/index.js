import React from "react";
import ReactDOM from "react-dom";
import { ChainId, DAppProvider, Config } from "@usedapp/core";

import "./index.css";
import { App } from "./App";
import reportWebVitals from "./reportWebVitals";

const config = {
  readOnlyChainId: ChainId.Ropsten,
  readOnlyUrls: {
    [ChainId.Ropsten]:
      "https://eth-ropsten.alchemyapi.io/v2/Wi3BQYuTli2a9nLkLVH13nWzbpyrrJfA",
  },
};

ReactDOM.render(
  <React.StrictMode>
    <DAppProvider config={config}>
      <App />
    </DAppProvider>
  </React.StrictMode>,
  document.getElementById("root")
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
