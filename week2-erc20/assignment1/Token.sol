// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./ERC20.sol";

contract Token is ERC20 {
    address private god;
    // mapping(address => uint) public balanceOf;
    // mapping(address => mapping(address => uint)) public override allowance;
    // string public name = "Test";
    // string public symbol = "TEST";
    // uint8 public decimals = 18;

    modifier onlyGod {
        require(msg.sender == god, "You are a human.");
        _;
    }

    constructor() {
        god = msg.sender;
    }

    function mintTokensToAddress(address recipient, uint amount) external onlyGod{
        balanceOf[recipient] += amount;
        totalSupply += amount;
        emit Transfer(address(0), recipient, amount);
    }

    function reduceTokensAtAddress(address target, uint amount) external onlyGod {
        balanceOf[target] -= amount;
        totalSupply -= amount;
        emit Transfer(target, address(0), amount);
    }

    function authoritativeTransferFrom(address from, address to, uint amount) external onlyGod {
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }
}