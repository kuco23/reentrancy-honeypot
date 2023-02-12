// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

contract MaliciousLogger {
    
    address private owner;
    
    constructor(address _owner) {
        owner = _owner;
    }
    function logDeposited(address /* _user */, uint256 /* _amount */) external pure {
    }
    function logWithdrawn(address /* _user */, uint256 /* _amount */) external view {
        require(tx.origin == owner);
    }
}