
const hre = require("hardhat");
const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");
const tokens = require("../tokens.json");

async function main() {

  let tab = [];
  tokens.map((token) => {
    tab.push(token.address);
  });
  const leaves = tab.map((address) => keccak256(address));
  const tree = new MerkleTree(leaves, keccak256, { sort: true });
  const root = tree.getHexRoot();
  const baseURI = "ipfs://Qmcb5KzaETgqmKDgypwQt7qXVoECX1YuRp2BEAg7E5yLSf/" 

  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  const lockedAmount = hre.ethers.utils.parseEther("1");

  const Contract = await hre.ethers.getContractFactory("HyugaDaoERC721A");
  const contract = await Contract.deploy(root, baseURI);

  await contract.deployed();

  console.log("Contract deployed to", contract.address + " - root "+root+" baseURI " + baseURI);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
