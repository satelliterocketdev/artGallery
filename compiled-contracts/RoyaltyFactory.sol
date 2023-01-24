pragma solidity >=0.4.22 <0.8.4;\n\n// SPDX-License-Identifier: MIT



/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}\n\n// SPDX-License-Identifier: MIT





/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts may inherit from this and call {_registerInterface} to declare
 * their support of an interface.
 */
abstract contract ERC165 is IERC165 {
    /*
     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
     */
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    /**
     * @dev Mapping of interface ids to whether or not it's supported.
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () internal {
        // Derived contracts need only register support for their own interfaces,
        // we register support for ERC165 itself here
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     *
     * Time complexity O(1), guaranteed to always use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    /**
     * @dev Registers the contract as an implementer of the interface defined by
     * `interfaceId`. Support of the actual ERC165 interface is automatic and
     * registering its interface id is not required.
     *
     * See {IERC165-supportsInterface}.
     *
     * Requirements:
     *
     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
     */
    function _registerInterface(bytes4 interfaceId) internal virtual {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}\n\n// SPDX-License-Identifier: MIT



contract RoyaltyFactory is ERC165 {
    mapping(uint256 => address) _originalCreators;
    mapping(uint256 => uint256) _royaltyFees; // 100% = 1000000, 1% = 10000
    /*
     *     bytes4(keccak256('setRoyaltyFee(uint256, uint256)')) == 0x4e30ff2d
     *     bytes4(keccak256('setOriginalCreator(uint256, uint256)')) == 0x1db8209f
     *     bytes4(keccak256('getRoyaltyFee(uint256)')) == 0x9e4c0141
     *     bytes4(keccak256('getOriginalCreator(uint256)')) == 0xcaa47fbf
     *
     *     => 0x4e30ff2d ^ 0x1db8209f ^ 0x9e4c0141 ^ 0xcaa47fbf == 0x0760a14c
     */
    bytes4 private constant _INTERFACE_ID_ROYALTY = 0x0760a14c;

    constructor() {
        _registerInterface(_INTERFACE_ID_ROYALTY);
    }

    function setRoyaltyFee(uint256 tokenID, uint256 fee) internal {
        _royaltyFees[tokenID] = fee;
    }

    function setOriginalCreator(uint256 tokenID, address creator) internal {
        _originalCreators[tokenID] = creator;
    }

    function getRoyaltyFee(uint256 tokenID)
        public
        view
        virtual
        returns (uint256)
    {
        return _royaltyFees[tokenID];
    }

    function getOriginalCreator(uint256 tokenID)
        public
        view
        virtual
        returns (address)
    {
        return _originalCreators[tokenID];
    }
}