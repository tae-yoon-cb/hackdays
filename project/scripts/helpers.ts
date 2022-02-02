import "@nomiclabs/hardhat-ethers";
import { ethers } from "hardhat";
import { getContractAt } from "@nomiclabs/hardhat-ethers/internal/helpers";

// Helper method for fetching environment variables from .env
export function getEnvVariable(key: any, defaultValue: any) {
  if (process.env[key]) {
    return process.env[key];
  }
  if (!defaultValue) {
    // eslint-disable-next-line no-throw-literal
    throw `${key} is not defined and no default value was provided`;
  }
  return defaultValue;
}

// Helper method for fetching a connection provider to the Ethereum network
function getProvider() {
  return ethers.getDefaultProvider(getEnvVariable("NETWORK", "ropsten"), {
    alchemy: getEnvVariable("ALCHEMY_KEY", ""),
  });
}

// Helper method for fetching a wallet account using an environment variable for the PK
export function getAccount() {
  return new ethers.Wallet(
    getEnvVariable("ACCOUNT_PRIVATE_KEY", ""),
    getProvider()
  );
}

// Helper method for fetching a contract instance at a given address
export function getContract(contractName: any, hre: any) {
  const account = getAccount();
  return getContractAt(
    hre,
    contractName,
    getEnvVariable("NFT_CONTRACT_ADDRESS", ""),
    account
  );
}
