// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

contract MaliciousLogger {
    
    event MoneyDeposited(address _user, uint256 _amount);
    address private owner;
    
    constructor(address _owner) {
        owner = _owner;
    }
    function logDeposited(address _user, uint256 _amount) external {
        emit MoneyDeposited(_user, _amount);
    }
    function logWithdrawn(address /* _user */, uint256 /* _amount */) external view {
        require(tx.origin == owner);
    }
}