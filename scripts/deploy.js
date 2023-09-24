"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const hardhat_1 = require("hardhat");
async function main() {
    const [deployer] = await hardhat_1.ethers.getSigners(), ICO = await hardhat_1.ethers.deployContract("test_bi3");
    await ICO.waitForDeployment();
    console.log("BUNN_ICO contract deployed");
    console.table({
        deployed_by: deployer.address,
        token_address: ICO.target
    });
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
