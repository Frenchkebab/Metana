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

    // assignment2 - ERC20 with sanctions
    function addToBlacklist(address _address) public onlyGod{
        blacklist[_address] = true;
    }

    function removeFromBlacklist(address _address) public onlyGod {
        // need to check blacklist[_address] == true ?
        blacklist[_address] = false;
    }

    // assignment3 - Tokensale with ethereum
    function mintTokenWithEth() public payable {
        require(totalSupply <= 900000, "Token supply exceeded 1 million. Sale Closed");
        require(msg.value == 1 ether, "You must send 1 ether");
        balanceOf[msg.sender] += 1000;
        totalSupply += 1000;
    }

    function withdrawEth() public onlyGod {
        (bool success, ) = payable(god).call{value: 1 ether}("");
        require(success, "Withdrawal failed");
    }

    // assignment4
    function transferToContract() public {
        require(balanceOf[msg.sender] >= 1000, "Insufficient balance");
        
        //! users need to give the smart contract approval to withdraw their ERC20 tokens from their balance.
        // question: cheaper than calling transfer(address(this)?)
        balanceOf[msg.sender] -= 1000;
        balanceOf[address(this)] += 1000;

        (bool success, ) = payable(msg.sender).call{value: 0.5 ether}("");
        require(success, "Withdrawal failed");
    }

    function buyTokenWithEth() public payable {
        if(totalSupply >= 1000000) {
            require(balanceOf[address(this)] >= 1000, "Not enough supply to sell");
            require(msg.value == 1 ether, "You must send 1 ether");
            balanceOf[address(this)] -= 1000;
            balanceOf[msg.sender] += 1000;
        } else {
            mintTokenWithEth();
        }
    }
}