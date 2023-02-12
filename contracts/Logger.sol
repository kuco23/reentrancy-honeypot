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