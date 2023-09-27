// Sources flattened with hardhat v2.17.3 https://hardhat.org

// SPDX-License-Identifier: MIT

// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}


// File @openzeppelin/contracts/interfaces/IERC20.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)

pragma solidity ^0.8.0;


// File contracts/BUNN_ICO.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.19;

contract test_bi21 {
    address public admin;
    address public ico_token;

    mapping(address => bool) public registered_addresses;
    mapping(address => bool) public claimed_addresses;

    uint256 public ico_start_time;
    uint256 public constant ICO_DURATION = 300; // Adjust the duration as needed

    event Claimed(address indexed _address, bool status);
    event Registered(address indexed _address, bool status);

    constructor() {
        admin = msg.sender; // Set the contract deployer as the admin
        ico_token = address(0x66A56B0638cAdf0303CaEA18E264F18ee6cA84bf);
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

    function claimtest_ico() external returns (bool) {
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
    function withdrawEther(uint256 amount) external onlyAdmin {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(admin).transfer(amount);
    }
}
