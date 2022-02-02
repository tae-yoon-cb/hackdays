import { useEthers } from "@usedapp/core";
import { utils, constants } from "ethers";

import Lottery from "../artifacts/contracts/NFTAlbum.sol/NFTAlbum.json";
import { getContractAddress } from "../utils/getContractAddress";

export const useGetContract = ({ contract }) => {
  const { chainId } = useEthers();
  const { abi } = Lottery;
  const contractAddress = chainId
    ? getContractAddress({
        chainId,
        contract,
      })
    : constants.AddressZero;
  const contractInterface = new utils.Interface(abi);

  return {
    contractAddress,
    contractInterface,
  };
};
