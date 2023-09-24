import { ethers } from "hardhat";

async function main() {
  const
    [deployer] = await ethers.getSigners(),
    ICO = await ethers.deployContract("test_bi4");

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
