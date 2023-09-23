"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
const config = {
    solidity: "0.8.19",
    networks: {
        sepolia: {
            url: "https://eth-sepolia.g.alchemy.com/v2/uJ6VyGFM0IqVjGXqi0pjDyhbwpp7h58I",
            // @ts-ignore
            accounts: [process.env.WALLET]
        }
    },
    etherscan: {
        apiKey: process.env.ETHERSCAN
    }
};
exports.default = config;
