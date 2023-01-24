// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./ArtFactory1155.sol";

contract ArtGallery1155 {
    using SafeMath for uint256;
    // mapping to save the symbol to Gallery Address
    mapping(string => address) symbolToGalleryAddress;
    //mapping to save all the gallery addresses of an owner
    mapping(address => address[]) userToGalleries;

    address lastaddress;
    string lastUri;
    // address public feeAccount = address(0x0000000000000000000000);
    address public _owner = address(0x0000000000000000000000);

    // ERC20 cifiTokenContract = ERC20(0xe56aB536c90E5A8f06524EA639bE9cB3589B8146);
    // ERC20 cifiTokenContract = ERC20(0x89F2a5463eF4e4176E57EEf2b2fDD256Bf4bC2bD);

    // uint256 FEE = 100;
    // uint8 cifiDecimals = cifiTokenContract.decimals();
    // uint256 public feeAmount = FEE.mul(10**cifiDecimals).div(100);

    event Gallery1155Created(
        string name,
        string symbol,
        string description,
        address caller,
        string uri,
        address galleryAddress
    );

    constructor() {
        // feeAccount = msg.sender;
        _owner = msg.sender;
    }

    function createGallery(
        string memory name,
        string memory symbol,
        string memory description,
        string memory uri
    ) public returns (address) {
        require(msg.sender != address(0), "Invalid address");
        require(bytes(name).length != 0, "name can't be empty");
        require(bytes(symbol).length != 0, "symbol can't be empty");
        uniqueSymbol(symbol);
        // cifiTokenContract.transferFrom(msg.sender, feeAccount, feeAmount);
        ArtFactory1155 gallery =
            new ArtFactory1155(
                name,
                symbol,
                description,
                uri,
                msg.sender,
                _owner
            );

        // adding the gallery address to the symbolToGalleryAddress
        symbolToGalleryAddress[symbol] = address(gallery);

        // saving the last gallery address
        lastaddress = address(gallery);

        // adding the gallery address to the uriToGalleryAddress

        // adding the address to address array for userToGalleries
        userToGalleries[msg.sender].push(address(gallery));

        emit Gallery1155Created(
            name,
            symbol,
            description,
            msg.sender,
            uri,
            address(gallery)
        );

        return address(gallery);
    }

    function uniqueSymbol(string memory symbol) public view returns (bool) {
        require(
            symbolToGalleryAddress[symbol] == address(0),
            "symbol already used"
        );
        return true;
    }

    function getlastAddress() public view returns (address) {
        return lastaddress;
    }

    function getGalleries(address _user)
        public
        view
        returns (address[] memory)
    {
        return userToGalleries[_user];
    }

    function getGallery(string memory _symbol) public view returns (address) {
        return symbolToGalleryAddress[_symbol];
    }
}
