//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Avatar is ERC721URIStorage, Ownable {
    //первоначальный выбор аватара: м_ж
    //список NFT коллекций
    //коллекция by defolt
    //одеть персонажа
    // NFT из рюкзака
    // NFT одетые

    ///////// Errors //////////
    error Avatar__ErrorIndex();
    error Avatar__SbtAlreadyMinted();
    error Avatar__NotEnoughMoney();
    error Avatar__ThisIsSolboundToken();

    //////// Libraries /////////
    using Counters for Counters.Counter;

    //////// Type Declaration ////////
    enum Place {
        STORE,
        WEAR
    }

    struct Clothes {
        address nftCollection;
        uint256[] tikenIds;
    }

    /////// State variables /////////
    Counters.Counter public s_tokenIdCounter = Counters.Counter({_value: 1});
    string[2] private s_IpfsUri = ["", ""];
    uint256 private s_mintedFee;
    mapping(address _user => uint256 _tokenId) private s_tokenId;
    mapping(uint256 _tokenId => mapping(Place => mapping(address _nftCollection => uint256[] _tokenIds)))
        private s_outfit;

    /////// Functions ////////
    constructor() ERC721("SBTAvatar", "SAVT") {}

    /////// Supported Interface ////////
    // дописать поддержку ERC-5192 https://eips.ethereum.org/EIPS/eip-5192

    /////// Modifiers /////////
    modifier mayMintSbt() {
        if (balanceOf(msg.sender) > 0) revert Avatar__SbtAlreadyMinted();
        _;
    }

    ////// Admin functions ///////
    function changeURIs(
        string memory manAvatar,
        string memory womanAvatar
    ) external onlyOwner {
        s_IpfsUri[0] = manAvatar;
        s_IpfsUri[1] = womanAvatar;
    }

    function setMintedFee(uint256 fee) external onlyOwner {
        s_mintedFee = fee;
    }

    //////// User Functions ////////
    function safeMint(uint256 index) public payable mayMintSbt {
        if (index > 1) revert Avatar__ErrorIndex();
        if (msg.value < s_mintedFee) revert Avatar__NotEnoughMoney();

        uint256 tokenId = s_tokenIdCounter.current();
        s_tokenIdCounter.increment();
        s_tokenId[msg.sender] = tokenId;

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, s_IpfsUri[index]);
    }

    function dressItem(address nftCollection, uint256 tokenId) external {
        //в работе
        //достаем из рюкзака и одеваем на аватар
    }

    function takeOffItem(address nftCollection, uint256 tokenId) external {
        //в работе
        //снимаем и кладем в рюкзак
    }

    ///////// Getters //////////
    function getTokenId(address _addr) external view returns (uint256) {
        return s_tokenId[_addr];
    }

    function getFromStore() external view returns (Clothes[] memory) {
        // возвращаем массив структур
    }

    function getFromWear() external view returns (Clothes[] memory) {
        // возвращаем массив структур
    }

    //////// Locked Transfer Functions /////////
    function approve(address, uint256) public pure override {
        revert Avatar__ThisIsSolboundToken();
    }

    function setApprovalForAll(address, bool) public pure override {
        revert Avatar__ThisIsSolboundToken();
    }

    function transferFrom(address, address, uint256) public pure override {
        revert Avatar__ThisIsSolboundToken();
    }

    function safeTransferFrom(address, address, uint256) public pure override {
        revert Avatar__ThisIsSolboundToken();
    }

    function safeTransferFrom(
        address,
        address,
        uint256,
        bytes memory
    ) public pure override {
        revert Avatar__ThisIsSolboundToken();
    }
}
