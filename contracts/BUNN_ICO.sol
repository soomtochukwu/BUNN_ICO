/**
 * @title BUNN_ICO - BUNN Token Initial Coin Offering (ICO) Contract
 * @dev This contract allows users to register and claim BUNN tokens during the ICO period.
 * The ICO is open for a specific duration, and registered addresses can claim tokens after the ICO ends.
 * Only the contract admin can withdraw Ether from the contract.
 */

//  SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Import OpenZeppelin ERC20 interface for interacting with the BUNN token
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract BUNN_ICO {
    address public admin; // Address of the contract admin
    address public ico_token; // Address of the BUNN token contract

    // Mapping to track registered and claimed addresses
    mapping(address => bool) public registered_addresses;
    mapping(address => bool) public claimed_addresses;

    uint256 public ico_start_time; // ICO start timestamp
    uint256 public constant ICO_DURATION = 86400; // ICO duration in seconds (adjust as needed)

    // Events to log registration and claiming status
    event Claimed(address indexed _address, bool status);
    event Registered(address indexed _address, bool status);

    /**
     * @dev Constructor function to initialize contract state
     */
    constructor() {
        admin = msg.sender; // Set the contract deployer as the admin
        ico_token = address(0x846C9D65404B5325163f2850DAcF7C3Dff9ef0B2);
        ico_start_time = block.timestamp;
    }

    /**
     * @dev Modifier to restrict access to admin-only functions
     */
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    /**
     * @dev Function to allow users to register for the ICO by sending 0.01 ETH
     * Users can only register once, and registration is allowed during the ICO period.
     */
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

    /**
     * @dev Function to allow registered users to claim BUNN tokens after the ICO has ended.
     * Each user can claim 50 BUNN tokens, and claiming is only allowed once per address.
     */
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

    /**
     * @dev Function to allow the admin to withdraw any remaining Ether in the contract
     * Only the contract admin can call this function.
     */
    function withdrawEther() external onlyAdmin {
        payable(admin).transfer(address(this).balance);
    }
}
