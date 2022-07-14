// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./ERC20.sol";

contract Token is ERC20 {
    uint constant TOKEN_DECIMAL = 10 ** 18;
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

    function transfer(address to, uint amount) public override checkBlacklist returns (bool)  {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function mintTokensToAddress(address recipient, uint amount) external onlyGod{
        _balances[recipient] += amount;
        _totalSupply += amount;
        emit Transfer(address(0), recipient, amount);
    }

    function reduceTokensAtAddress(address target, uint amount) external onlyGod {
        _balances[target] -= amount;
        _totalSupply -= amount;
        emit Transfer(target, address(0), amount);
    }

    function authoritativeTransferFrom(address from, address to, uint amount) external onlyGod {
        _balances[from] -= amount;
        _balances[to] += amount;
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
        require(totalSupply() <= 900000 * TOKEN_DECIMAL, "Token supply exceeded 1 million. Sale Closed");
        require(msg.value == 1 ether, "You must send 1 ether");
        _balances[msg.sender] += 1000 * TOKEN_DECIMAL;
        _totalSupply += 1000 * TOKEN_DECIMAL;
    }

    function withdrawEth() public onlyGod {
        (bool success, ) = payable(god).call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }

    // assignment4
    /**
      * Transfer 1000 tokens to the contract, and get 0.5 eth
      **/
    function sellTokens() public {
        require(balanceOf(msg.sender) >= 1000 * TOKEN_DECIMAL, "Insufficient balance");
        _allowances[msg.sender][address(this)] = 1000 * TOKEN_DECIMAL;
        
        //! users need to give the smart contract approval to withdraw their ERC20 tokens from their balance.
        // question: cheaper than calling transfer(address(this)?)
        transferFrom(msg.sender, address(this), 1000 * TOKEN_DECIMAL);

        require(address(this).balance >= 0.5 ether, "Contract does not have enough ethers");
        (bool success, ) = payable(msg.sender).call{value: 0.5 ether}("");
        require(success, "Withdrawal failed");
    }

    function buyTokenWithEth() public payable {
        if(_totalSupply >= 1000000 * TOKEN_DECIMAL) {
            require(balanceOf(address(this)) >= 1000 * TOKEN_DECIMAL, "Not enough supply to sell");
            require(msg.value == 1 ether, "You must send 1 ether");
            _balances[address(this)] -= 1000 * TOKEN_DECIMAL;
            _balances[msg.sender] += 1000 * TOKEN_DECIMAL;
        } else {
            mintTokenWithEth();
        }
    }
}