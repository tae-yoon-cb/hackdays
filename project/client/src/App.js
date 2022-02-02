import { useEthers } from "@usedapp/core";
import { useEffect, useState } from "react";
import styled from "styled-components";

import { RequireRopsten } from "./components/RequireRopsten";
import { RequireWeb3 } from "./components/RequireWeb3";
import { Page } from "./components/Page";

import getWeb3 from "./getWeb3";

export const App = () => {
  const [isMounted, setIsMounted] = useState(false);
  const { chainId, account, activateBrowserWallet } = useEthers();

  useEffect(() => {
    // Check for web3 and pop it open
    // @usedapp doesn't currently suppor this feature
    const loadWeb3 = async () => {
      try {
        await getWeb3();
      } catch (error) {
        console.error("An error occured:", error);
      }

      setIsMounted(true);
      await activateBrowserWallet();
    };

    loadWeb3();
  }, []);

  let Content = <Page />;

  if (!isMounted) {
    Content = <Loader>Loading...</Loader>;
  } else if (!account) {
    Content = <RequireWeb3 />;
  } else if (chainId !== 3) {
    Content = <RequireRopsten />;
  }

  return (
    <AppWrapper>
      <AppContent>{Content}</AppContent>
    </AppWrapper>
  );
};

const AppWrapper = styled.div`
  max-width: 550px;
  width: 100%;
  margin: 20px auto;
  font-size: 20px;
  line-height: 1.4;
  border: 1px solid black;
  border-radius: 8px;
  box-sizing: border-box;
`;

const AppContent = styled.div`
  padding: 20px;
  height: 700px;
  overflow-y: scroll;
`;

const Loader = styled.div`
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding-top: 40px;
`;
