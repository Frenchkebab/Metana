## assignment4

Description
WARNING! THIS ASSIGNMENT IS TRICKIER THAN THE EARLIER ONES.

Take what you did in assignment 4 and give the users the ability to transfer their tokens to the contract and receive 0.5 ether for every 1000 tokens they transfer.

ERC20 tokens don’t have the ability to trigger functions on smart contracts. Users need to give the smart contract approval to withdraw their ERC20 tokens from their balance. See here: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol#L136
The smart contract should block the transaction if the smart contract does not have enough ether to pay the user.
If another user wants to buy tokens from the contract, and the supply has already been used up, and the contract is holding tokens that other people sent in, it must sell them those tokens at the original price of 1 ether per 1000 tokens.