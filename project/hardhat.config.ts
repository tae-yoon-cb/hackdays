import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "@typechain/hardhat";
import "solidity-coverage";

import "@nomiclabs/hardhat-web3";
import "hardhat-deploy";
import { getContract } from "./scripts/helpers";

dotenv.config();

task("mint", "Mints from the NFT contract")
  .addParam("address", "The address to receive a token")
  .setAction(async function (taskArguments, hre) {
    const contract = await getContract("MoNFT", hre);
    const transactionResponse = await contract.mintTo(taskArguments.address, {
      gasLimit: 500_000,
    });
    console.log(`Transaction Hash: ${transactionResponse.hash}`);
  });

task("balance", "Prints an account's balance")
  .addParam("account", "The account's address")
  .setAction(async (taskArgs, { web3 }) => {
    const account = web3.utils.toChecksumAddress(taskArgs.account);
    const balance = await web3.eth.getBalance(account);

    console.log(web3.utils.fromWei(balance, "ether"), "ETH");
  });

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  namedAccounts: {
    deployer: 0,
  },
  networks: {
    ropsten: {
      url: process.env.ROPSTEN_URL || "",
      accounts: {
        mnemonic: process.env.MNEMONIC || "",
      },
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};

export default config;
