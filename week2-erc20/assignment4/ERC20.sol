// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}

// this contract implements all functions above
contract ERC20 is IERC20 {
    uint public _totalSupply;
    mapping(address => uint) private _balances;
    mapping(address => mapping(address => uint)) private _allowances;
    string private _name = "Test";
    string private _symbol = "TEST";
    uint8 private _decimals = 18;


    /**
      * getter functions here
      */
    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint256) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }


    /**
      * setter functions here
      */
    // question: virtual
    function transfer(address to, uint amount) public virtual override returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint amount
    ) external override returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function mint(uint amount) external {
        _balances[msg.sender] += amount;
        _totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    // Newly Added

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        require(from != address(0), "Transfer from the zero address");
        require(to != address(0), "Transfer to the zero address");

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "Transfer amount exceeds balance");

        emit Transfer(from, to, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "Approve from the zero address");
        require(spender != address(0), "Approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        uint256 currentAllowance = _allowances[owner][spender];
        require(currentAllowance >= amount, "Insufficient Allowance");
        _approve(owner, spender, currentAllowance - amount);
    }
}