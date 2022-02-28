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

    mapping(address => uint8) public userState;

    constructor() ERC721("MFI Global Ambassador", "MFI Global Ambassador") {}

    function tokenURIs() public pure returns (string memory output) {
        output = string('{"name": "MFI Global Ambassador", "description": "Rewards for MFI Community Global Ambassador Assignments", "image": "https://ipfs.io/ipfs/QmRk5FPuhRRE6nTTP5zEFQM738xZYq92KKGazcBKbbgH9a"}');
        return output;
    }

    /**
    * @notice Upload user list
    * @dev onlyOwner use
    * @param addrlist User list
    */
    function addressList(address[] calldata addrlist) public onlyOwner {
        for (uint64 i = 0; i < addrlist.length; i++) {
            userState[addrlist[i]] = 1;
        }
    }

    function awardItem() public returns (uint256){
        require(userState[msg.sender] == 1, "not whitelisted");
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURIs());
        userState[msg.sender] = 2;
        return newItemId;
    }

}