require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-chai-matchers");
require("@nomiclabs/hardhat-etherscan");
let sercrets = require("./secrets.json");
require("dotenv").config();
const{INFURA, PRIVATE_KEY, ETHERSCAN_API_KEY} = process.env;

task('verify:hyuga', async (taskArgs, hre) => {
  await hre.run('verify:verify', {
    address: '0xE85e5fE30060756c6addE981C7EdaD77f9F7a6BB', 
    constructorArguments: ['0xedc0eb94bae06e84bc6af5cd5bed7c120121fe64af5bf38104313a95caaefa54', 'ipfs://Qmcb5KzaETgqmKDgypwQt7qXVoECX1YuRp2BEAg7E5yLSf/']
  })
});

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
      version: "0.8.12",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        }
      }
  },
  paths: {
    artifacts: './artifacts'
  },
  defaultNetwork: "rinkeby",
    networks: {
      rinkeby: {
        url: INFURA,
        accounts: [`0x${PRIVATE_KEY}`]
      }
    },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  }
}; 