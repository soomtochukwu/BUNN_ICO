const
    { network } = require("hardhat"),
    { verify } = require("../utils/verify");

require("dotenv").config();

module.exports = async ({ getNamedAccounts, deployments }) => {
    const
        { deployer } = await getNamedAccounts(),
        { deploy } = await deployments;

    // deploy our contracts
    const
        NFTContract = await deploy("BUNN_ICO", {
            from: deployer,
            args: [],
            log: true,
            waitConfirmations: network.config.blockConfirmations,
        })

    // verify our contact
    const ETHERSCAN_KEY = process.env.ETHERSCAN_KEY;
    if (network.config.chainId !== 31337 && ETHERSCAN_KEY) {
        await verify(
            NFTContract.address,
            [],
            "contracts/BUNN_ICO.sol:BUNN_ICO"
        )
    }
}

module.exports.tags = ["all", "nft"]