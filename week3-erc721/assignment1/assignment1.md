## Description

Look here:

https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol

and here

https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Pausable.sol

What added functionality do these contracts provide? What are the risks of the Pausable contract?

## Answer

### ERC721URIStorage

ERC721.sol

```solidity
function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    _requireMinted(tokenId);

    string memory baseURI = _baseURI();
    return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
}
```

In `ERC721.sol`, the tokenURI is dynamically made by concatinating basURI and tokenId.
There is no storage for URI to be stored in the blockchain in this contract.

`ERC721URIStorage.sol` contract provides a mapping that you can store tokenURIs for each token.

### ERC721Pausable

`ERC721Pausable` overrides `_beforeTokenTransfer` function which reverts contract when `_paused == true`.
Functions in `ERC721.sol` which have `_beforeTokenTransfer()` will be reverted when `_paused == true`, which means
you won't be able to transfer, mint, or burn token.

The risk of `ERC721Pausable` might be the fact that the contract owner has the power to lock up the token that people own,
which just happened recently with Celcius.
