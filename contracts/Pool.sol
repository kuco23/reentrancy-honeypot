// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

contract Logger {
    event MoneyDeposited(address _user, uint256 _amount);
    event MoneyWithdrawn(address _user, uint256 _amount);
    function logDeposited(address _user, uint256 _amount) external {
        emit MoneyDeposited(_user, _amount);
    }
    function logWithdrawn(address _user, uint256 _amount) external {
        emit MoneyWithdrawn(_user, _amount);
    }
}

contract Pool {

    mapping(address => bool) invested;
    Logger public logger;

    constructor(address _logger) {
        logger = Logger(_logger);
    }

    function invest() external payable {
        require(!invested[msg.sender], "Investment can only be done once!");
        require(msg.value == 1 ether, "Only 1ETH investments are accepted!");
        invested[msg.sender] = true;
        logger.logDeposited(msg.sender, msg.value);
    }

    function withdraw() external {
        require(invested[msg.sender], "You have no funds to withdraw!");
        (bool success,) = msg.sender.call{value: 1 ether}("");
        require(success, "External call success required to withdraw funds!");
        invested[msg.sender] = false;
        logger.logWithdrawn(msg.sender, 1 ether);
    }
}