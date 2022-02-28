// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GameItem is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(address => bool) public userState;

    constructor() ERC721("MFI Global Ambassador", "MFI Global Ambassador") {}

    function tokenURIs() public pure returns (string memory output) {
        output = string('{"name": "MFI Global Ambassador", "description": "Rewards for MFI Community Global Ambassador assignments", "image": "https://ipfs.io/ipfs/QmRk5FPuhRRE6nTTP5zEFQM738xZYq92KKGazcBKbbgH9a"}');
        return output;
    }

    /**
    * @notice Upload user list
    * @dev onlyOwner use
    * @param addrlist User list
    */
    function addressList(address[] calldata addrlist) public onlyOwner {
        for (uint64 i = 0; i < addrlist.length; i++) {
            userState[addrlist[i]] = true;
        }
    }

    function awardItem() public returns (uint256){
        require(userState[msg.sender], "not whitelisted");
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURIs());

        return newItemId;
    }

}