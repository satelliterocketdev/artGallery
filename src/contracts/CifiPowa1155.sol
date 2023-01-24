// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./library/Governance.sol";
import "./interface/RoyaltyFactory.sol";

contract CifiPowa1155 is ERC1155, Governance, RoyaltyFactory {
    using SafeMath for uint256;
    string public name;
    string public symbol;
    uint256 private _lastTokenID = 0;

    ERC20 cifiTokenContract = ERC20(0xe56aB536c90E5A8f06524EA639bE9cB3589B8146);
    // ERC20 cifiTokenContract = ERC20(0x89F2a5463eF4e4176E57EEf2b2fDD256Bf4bC2bD);
    mapping(uint256 => address) public creators;
    address public feeAccount = address(0x0000000000000000000000);
    uint256 FEE = 100;
    uint8 cifiDecimals = cifiTokenContract.decimals();
    uint256 public feeAmount = FEE.mul(10**cifiDecimals).div(100);

    constructor() ERC1155("https://ipfs.io/ipfs/") {
        name = "Cifipowa1155";
        symbol = "POWA1";
        feeAccount = msg.sender;
    }

    function setURIPrefix(string memory baseURI) public onlyGovernance {
        _setURI(baseURI);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount
    ) public {
        super.safeTransferFrom(from, to, id, amount, "");
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts
    ) public {
        super.safeBatchTransferFrom(from, to, ids, amounts, "");
    }

    /**
     * this function allows to mint more of your Art
     */
    function mint(uint256 amount, uint256 royaltyFee)
        external
        onlyGovernance
        returns (bool)
    {
        _lastTokenID++;
        require(amount != 0, "Amount should be positive");
        setOriginalCreator(_lastTokenID, _msgSender());
        setRoyaltyFee(_lastTokenID, royaltyFee);
        cifiTokenContract.transferFrom(msg.sender, feeAccount, feeAmount);
        _mint(_msgSender(), _lastTokenID, amount, "");
        return true;
    }

    /**
     * this function allows you burn your Art
     */
    function burn(
        address account,
        uint256 id,
        uint256 amount
    ) public returns (bool) {
        require(
            isApprovedForAll(account, _msgSender()),
            "ArtFactory: Invalid operator"
        );
        _burn(account, id, amount);
        return true;
    }
}
