const hre = require("hardhat");

async function main() {
  const CardCollection = await hre.ethers.getContractFactory("CardCollection");
  const contract = CardCollection.attach(
    "0x0BCF70d6D894a1D195e26C2ED9381fD57F900E9b" // Deployed contract address
  );
  const mintedNft = await contract.buyPack(
    "0x8243fcD2617E0708489B61AfE60342E449992b4C" // Reciever wallet address
  );

  console.log("token minted", mintedNft);
}

main()
  // eslint-disable-next-line no-process-exit
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    throw error;
  });
