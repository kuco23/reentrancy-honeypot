// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "./Logger.sol";

contract Pool {

    mapping(address => uint256) invested;
    Logger public logger;

    constructor(address _logger) {
        logger = Logger(_logger);
    }

    function depositFunds() external payable {
        require(msg.value >= 1 ether, "Minimum investment is one ether!");
        invested[msg.sender] += 1;
        logger.logDeposited(msg.sender, msg.value);
    }

    function withdrawFunds() external {
        uint256 senderFunds = invested[msg.sender] * 1e18;
        require(senderFunds > 0, "You have no funds to withdraw!");
        (bool success,) = msg.sender.call{value: senderFunds}("");
        require(success, "Success required to change state!");
        invested[msg.sender] = 0;
        logger.logWithdrawn(msg.sender, senderFunds);
    }
}