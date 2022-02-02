import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();

  await deploy("CardCollection", {
    from: deployer,
    args: ["ipfs://QmaBAT25ferdCHvqxqXst7cw1AKxn2r2zNjWDiHXnqVanQ/"], // CID of json metadata folder
    log: true,
  });
};

export default func;

func.tags = ["CardCollection"];
