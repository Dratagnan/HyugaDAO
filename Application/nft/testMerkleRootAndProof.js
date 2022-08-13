const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");
const tokens = require("./tokens.json");

async function main() {
  let tab = [];
  tokens.map((token) => {
    tab.push(token.address);
  });
  const leaves = tab.map((address) => keccak256(address));
  const tree = new MerkleTree(leaves, keccak256, { sort: true });
  const root = tree.getHexRoot();
  const leaf = keccak256("0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db");
  const proof = tree.getHexProof(leaf);
  console.log("root : " + root);
  console.log("proof : " + proof);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});
// ["0x5931b4ed56ace4c46b68524cb5bcbf4195f1bbaacbe5228fbd090546c88dd229","0x52d130a40298e9a9b3c9fba4e3e2f760dd8ceda63c8b16f666b3e3babddfefa5"]
// ["0x999bf57501565dbd2fdcea36efa2b9aef8340a8901e3459f4a4c926275d36cdb","0x52d130a40298e9a9b3c9fba4e3e2f760dd8ceda63c8b16f666b3e3babddfefa5"]