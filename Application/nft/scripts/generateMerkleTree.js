
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

  console.log(" - root "+root+" baseURI " + baseURI);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
