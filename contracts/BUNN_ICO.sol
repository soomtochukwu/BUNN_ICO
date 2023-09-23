// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import "../interface/IICO.sol";

contract test_bi {
    address public admin;
    address public token_address;

    mapping(address => bool) registered_addresses;
    mapping(address => bool) claimed_addresses;

    uint256 public ico_start_time;
    uint256 public immutable ICO_DURATION = 360;

    event claimed(address indexed _address, bool status);
    event registered(address indexed _address, bool status);

    constructor() {
        admin = 0x49f2451AbEe35B261bB01f9d0CDC49f8f8df6E3f;
        token_address = 0x43c46Ea71642CC1CD97F872eD87Df2bbc84Ea622;
        ico_start_time = block.timestamp;
    }

    function register() public payable {
        require(
            msg.value == 0.01 ether,
            "Not SPECIFIED AMOUNT, PLEASE TRY AGAIN WITH 0.01 ETH."
        );

        require(
            !(registered_addresses[msg.sender]),
            "ADDRESS ALREADY REGISTERED."
        );

        uint256 elapsed_time = block.timestamp + ico_start_time;
        uint256 ico_end_time = block.timestamp + ICO_DURATION;

        require(elapsed_time < ico_end_time, "SORRY, ICO HAS ENDED");

        registered_addresses[msg.sender] = true;

        emit registered(msg.sender, true);
    }

    function claim() external returns (bool) {
        uint256 elapsed_time = block.timestamp + ico_start_time;
        uint256 ico_end_time = block.timestamp + ICO_DURATION;

        require(elapsed_time > ico_end_time, "SORRY, ICO NOT AVAILABLE");

        require(registered_addresses[msg.sender], "INVALID USER");

        require(
            !(claimed_addresses[msg.sender]),
            "THIS USER HAS ALREADY CLAIMED THEIR TOKEN(s)"
        );

        IERC20 BUNN = IERC20(token_address);
        BUNN.transferFrom(admin, msg.sender, 50);

        claimed_addresses[msg.sender] = true;

        emit claimed(msg.sender, true);

        return true;
    }
}
