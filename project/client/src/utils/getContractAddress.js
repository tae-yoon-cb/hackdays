import { getChainName } from "@usedapp/core";

import deploysMap from "../artifacts/deploys.json";

export const getContractAddress = ({ chainId, contract }) => {
  const chainName = getChainName(chainId)?.toLocaleLowerCase();

  return deploysMap[chainId]?.[chainName]?.contracts?.[contract]?.address;
};
