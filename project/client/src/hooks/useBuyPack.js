import { useContractFunction } from "@usedapp/core";
import { Contract } from "@ethersproject/contracts";

import { useGetContract } from "./useGetContract";

export const useBuyPack = () => {
  const { contractInterface, contractAddress } = useGetContract({
    contract: "NFTAlbum",
  });

  const contract = new Contract(contractAddress, contractInterface);

  return useContractFunction(contract, "createCollection", {
    transactionName: "Create collection",
  });
};
