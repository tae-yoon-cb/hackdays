import { useContractCall } from "@usedapp/core";

import { useGetContract } from "./useGetContract";

export const useGetAllCollections = () => {
  const { contractInterface, contractAddress } = useGetContract({
    contract: "NFTAlbum",
  });

  const [state] =
    useContractCall({
      abi: contractInterface,
      address: contractAddress,
      method: "getAllCollections",
      args: [],
    }) ?? [];

  return {
    state,
  };
};
