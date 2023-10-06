require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("hardhat-deploy");

const
  SEPOLIA_RPC = process.env.SEPOLIA_RPC,
  PRIVATE_KEY = process.env.PRIVATE_KEY,
  ETHERSCAN_KEY = process.env.ETHERSCAN_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  defaultNetwork: "hardhat",
  networks: {
    sepolia: {
      url: "https://eth-sepolia.g.alchemy.com/v2/9E2aTJwVzphtoZ59u4-dD7mKIA4-o__A",
      accounts: [PRIVATE_KEY,],
      chainId: 11155111,
      blockConfirmations: 5,
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_KEY,
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
};