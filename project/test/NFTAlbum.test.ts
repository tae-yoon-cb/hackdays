import { expect } from "chai";
import { Signer } from "ethers";
import { deployments, ethers } from "hardhat";

import { NFTAlbum, NFTAlbum__factory } from "../typechain"

describe("NFTAlbum", function () {
  let nftAlbumInstance: NFTAlbum;
  let accounts: Signer[];

  beforeEach(async () => {
    accounts = await ethers.getSigners();

    await deployments.fixture("NFTAlbum");
    const NFTAlbumDeployment = await deployments.get("NFTAlbum");

    nftAlbumInstance = NFTAlbum__factory.connect(
      NFTAlbumDeployment.address,
      accounts[0]
    );
  });
  
  it("Should create a collection", async () => {
    const createCollectionTx = await nftAlbumInstance
      .connect(accounts[0])
      .createCollection("Test Collection");
    // wait until the transaction is mined
    await createCollectionTx.wait();

    const createdCollection = await nftAlbumInstance.getCollectionInfo(1);
    const allCollections = await nftAlbumInstance.getAllCollections();
    
    expect(createdCollection[0]).to.equal("Test Collection");
    expect(allCollections.length).to.equal(1);
  });
});
