// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../interface/IICO.sol";

contract test_bi17 {
    address public admin;
    address public token_address;

    mapping(address => bool) public registered_addresses;
    mapping(address => bool) public claimed_addresses;

    uint256 public ico_start_time;
    uint256 public constant ICO_DURATION = 300; // Adjust the duration as needed

    event Claimed(address indexed _address, bool status);
    event Registered(address indexed _address, bool status);

    constructor() {
        admin = msg.sender; // Set the contract deployer as the admin
        token_address = address(0x66A56B0638cAdf0303CaEA18E264F18ee6cA84bf); // Replace with the correct token address
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

        IERC20 BUNN = IERC20(token_address);

        BUNN.transfer(msg.sender, 50);

        claimed_addresses[msg.sender] = true;

        emit Claimed(msg.sender, true);

        return true;
    }

    // Function to allow the admin to withdraw any remaining Ether in the contract
    function withdrawEther(uint256 amount) external onlyAdmin {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(admin).transfer(amount);
    }
}
