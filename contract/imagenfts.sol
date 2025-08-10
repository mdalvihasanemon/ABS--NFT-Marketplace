// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

contract ImageNFT is ERC721URIStorage, Ownable, ReentrancyGuard, IERC2981 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct TokenDetails {
        address creator;
        uint256 price;
        bool isListed;
    }

    mapping(uint256 => TokenDetails) public tokenDetails;
    uint256 public commissionRate = 15; // 1.5% (15/1000)
    uint256 public platformShare = 30; // 30% of commission

    event Minted(address indexed to, uint256 indexed tokenId, string tokenURI);
    event Listed(uint256 indexed tokenId, uint256 price);
    event Unlisted(uint256 indexed tokenId);
    event Sold(address indexed buyer, uint256 indexed tokenId, uint256 price);
    event CommissionRateChanged(uint256 newRate);
    event PlatformShareChanged(uint256 newShare);
    event FundsWithdrawn(address indexed recipient, uint256 amount);
    event RoyaltyPaid(address indexed creator, uint256 amount);
    event TokenURIUpdated(uint256 indexed tokenId, string newURI);

    constructor() ERC721("ImageNFT", "IMGNFT") Ownable(msg.sender) {}

    function mint(
        address to,
        string memory _tokenURI
    ) public returns (uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);

        tokenDetails[newTokenId] = TokenDetails({
            creator: msg.sender,
            price: 0,
            isListed: false
        });

        emit Minted(to, newTokenId, _tokenURI);
        return newTokenId;
    }

    function mintAndList(
        address to,
        string memory _tokenURI,
        uint256 price
    ) public returns (uint256) {
        uint256 tokenId = mint(to, _tokenURI);
        listForSale(tokenId, price);
        return tokenId;
    }

    function listForSale(uint256 tokenId, uint256 price) public {
        require(_ownerOf(tokenId) != address(0), "Token doesn't exist");
        require(ownerOf(tokenId) == msg.sender, "Not owner");
        require(price > 0, "Price must be > 0");

        // Auto-approve contract if needed
        if (!isApprovedForAll(msg.sender, address(this))) {
            _setApprovalForAll(msg.sender, address(this), true);
        }

        tokenDetails[tokenId].price = price;
        tokenDetails[tokenId].isListed = true;
        emit Listed(tokenId, price);
    }

    function unlist(uint256 tokenId) public {
        require(_ownerOf(tokenId) != address(0), "Token doesn't exist");
        require(ownerOf(tokenId) == msg.sender, "Not owner");
        require(tokenDetails[tokenId].isListed, "NFT not listed");

        tokenDetails[tokenId].price = 0;
        tokenDetails[tokenId].isListed = false;
        emit Unlisted(tokenId);
    }

    function buyNFT(uint256 tokenId) public payable nonReentrant {
        require(_ownerOf(tokenId) != address(0), "Token doesn't exist");
        require(tokenDetails[tokenId].isListed, "Not for sale");

        uint256 price = tokenDetails[tokenId].price;
        require(msg.value >= price, "Insufficient funds");

        // Refund excess ETH
        if (msg.value > price) {
            Address.sendValue(payable(msg.sender), msg.value - price);
        }

        address seller = ownerOf(tokenId);
        address creator = tokenDetails[tokenId].creator;

        // Calculate commissions
        uint256 totalCommission = (price * commissionRate) / 1000;
        uint256 platformAmount = (totalCommission * platformShare) / 100;
        uint256 creatorAmount = totalCommission - platformAmount;
        uint256 sellerProceeds = price - totalCommission;

        // Reset listing
        tokenDetails[tokenId].price = 0;
        tokenDetails[tokenId].isListed = false;

        // Transfer NFT
        _safeTransfer(seller, msg.sender, tokenId, "");

        // Distribute funds (fixed order for security)
        Address.sendValue(payable(seller), sellerProceeds);
        Address.sendValue(payable(creator), creatorAmount);
        Address.sendValue(payable(owner()), platformAmount);

        emit Sold(msg.sender, tokenId, price);
        emit RoyaltyPaid(creator, creatorAmount);
    }

    function updateTokenURI(uint256 tokenId, string memory newURI) public {
        address tokenOwner = ownerOf(tokenId);
        require(
            msg.sender == tokenOwner ||
                isApprovedForAll(tokenOwner, msg.sender) ||
                getApproved(tokenId) == msg.sender,
            "Caller not owner nor approved"
        );
        _setTokenURI(tokenId, newURI);
        emit TokenURIUpdated(tokenId, newURI);
    }

    // ERC2981 Royalty Info
    function royaltyInfo(
        uint256 tokenId,
        uint256 salePrice
    ) external view returns (address receiver, uint256 royaltyAmount) {
        require(_ownerOf(tokenId) != address(0), "Nonexistent token");
        uint256 totalCommission = (salePrice * commissionRate) / 1000;
        uint256 creatorAmount = (totalCommission * (100 - platformShare)) / 100;
        return (tokenDetails[tokenId].creator, creatorAmount);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721URIStorage, IERC165) returns (bool) {
        return
            interfaceId == type(IERC2981).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function setCommissionRate(uint256 newRate) public onlyOwner {
        require(newRate <= 100, "Max 10% commission");
        commissionRate = newRate;
        emit CommissionRateChanged(newRate);
    }

    function setPlatformShare(uint256 newShare) public onlyOwner {
        require(newShare <= 100, "Invalid share percentage");
        platformShare = newShare;
        emit PlatformShareChanged(newShare);
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds available");
        Address.sendValue(payable(owner()), balance);
        emit FundsWithdrawn(owner(), balance);
    }

    function getTokenDetails(
        uint256 tokenId
    )
        public
        view
        returns (
            address owner,
            address creator,
            uint256 price,
            string memory uri,
            bool isListed
        )
    {
        require(_ownerOf(tokenId) != address(0), "Token doesn't exist");
        return (
            ownerOf(tokenId),
            tokenDetails[tokenId].creator,
            tokenDetails[tokenId].price,
            tokenURI(tokenId),
            tokenDetails[tokenId].isListed
        );
    }

    function tokenURIById(
        uint256 _tokenId
    ) external view returns (string memory) {
        return tokenURI(_tokenId);
    }

    function totalSupply() external view returns (uint256) {
        return _tokenIds.current();
    }
}
