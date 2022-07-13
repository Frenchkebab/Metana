// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./ERC20.sol";

contract Token is ERC20 {
    address god;
    // this were unaccessible because it was decleared to be external
    // mapping(address => uint) public balanceOf; 
    // mapping(address => mapping(address => uint)) public override allowance;
    // string public name = "Test";
    // string public symbol = "TEST";
    // uint8 public decimals = 18;
    mapping (address => bool) blacklist;

    modifier onlyGod {
        require(msg.sender == god, "You are a human.");
        _;
    }

    modifier checkBlacklist {
        require(!blacklist[msg.sender], "The caller is on the blacklist");
        _;
    }

    constructor() {
        god = msg.sender;
    }

    function transfer(address recipient, uint amount) public override checkBlacklist returns (bool)  {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
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

    function addToBlacklist(address _address) public onlyGod{
        blacklist[_address] = true;
    }

    function removeFromBlacklist(address _address) public onlyGod {
        // need to check blacklist[_address] == true ?
        blacklist[_address] = false;
    }
}