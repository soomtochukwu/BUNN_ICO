const
    { network } = require("hardhat"),
    { verify } = require("../utils/verify"),
    { ethers } = require("hardhat");


require("dotenv").config();

module.exports = async ({ getNamedAccounts, deployments }) => {
    const
        { deployer } = await getNamedAccounts(),
        { deploy } = await deployments,
        [deployer_] = await ethers.getSigners(),
        _admin = `${deployer_.address}`,
        _ico_token = "0x846C9D65404B5325163f2850DAcF7C3Dff9ef0B2",
        _ico_start_time = Math.round(Date.now() / 1000)
        ;
    console.table({
        deployer: _admin,
        _ico_start_time: _ico_start_time,
        _ico_token: _ico_token
    })
    // deploy our contracts
    const
        ICOContract = await deploy("testICO000", {
            from: deployer,
            args: [_admin, _ico_token, _ico_start_time],
            log: true,
            waitConfirmations: network.config.blockConfirmations,
        })

    // verify our contact
    const ETHERSCAN_KEY = process.env.ETHERSCAN_KEY;
    if (network.config.chainId !== 31337 && ETHERSCAN_KEY) {
        await verify(
            ICOContract.address,
            [_admin, _ico_token, _ico_start_time],
            "contracts/BUNN_ICO.sol:testICO000"
        )
    }
}

module.exports.tags = ["all", "nft"]