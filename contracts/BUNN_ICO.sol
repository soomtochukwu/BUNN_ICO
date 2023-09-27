// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract BUNN_ICO {
    address public admin;
    address public ico_token;

    mapping(address => bool) public registered_addresses;
    mapping(address => bool) public claimed_addresses;

    uint256 public ico_start_time;
    uint256 public constant ICO_DURATION = 86400; // Adjust the duration as needed

    event Claimed(address indexed _address, bool status);
    event Registered(address indexed _address, bool status);

    constructor() {
        admin = msg.sender; // Set the contract deployer as the admin
        ico_token = address(0x846C9D65404B5325163f2850DAcF7C3Dff9ef0B2);
        ico_start_time = block.timestamp;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    function register() external payable {
        require(
            msg.value == 0.01 ether,
            "Incorrect amount, please send 0.01 ETH"
        );
        require(
            !registered_addresses[msg.sender],
            "Address already registered"
        );

        uint256 ico_end_time = ico_start_time + ICO_DURATION;

        require(block.timestamp < ico_end_time, "ICO has ended");

        registered_addresses[msg.sender] = true;

        emit Registered(msg.sender, true);
    }

    function claim() external returns (bool) {
        uint256 ico_end_time = ico_start_time + ICO_DURATION;
        require(block.timestamp > ico_end_time, "ICO is still ongoing");
        require(registered_addresses[msg.sender], "Address is not registered");
        require(
            !claimed_addresses[msg.sender],
            "Address has already claimed tokens"
        );

        IERC20 BUNN = IERC20(ico_token);

        BUNN.transferFrom(admin, msg.sender, 50e18);

        claimed_addresses[msg.sender] = true;

        emit Claimed(msg.sender, true);

        return true;
    }

    // Function to allow the admin to withdraw any remaining Ether in the contract
    function withdrawEther() external onlyAdmin {
        payable(admin).transfer(address(this).balance);
    }
}
