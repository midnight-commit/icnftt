// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {IERC4906} from "@openzeppelin/contracts/interfaces/IERC4906.sol";
import {IERC165} from "@openzeppelin/contracts/interfaces/IERC165.sol";
/**
 * @dev ERC721 token with storage based token URI management.
 *
 * @notice This is a customized version of OpenZeppelin's ERC721URIStorage contract.
 */

abstract contract ERC721URIStorageExtension is IERC4906, ERC721 {
    using Strings for uint256;

    bytes4 internal constant URI_STORAGE_EXTENSION_ID = bytes4(0x785680e6);

    // Interface ID as defined in ERC-4906. This does not correspond to a traditional interface ID as ERC-4906 only
    // defines events and does not include any external function.
    bytes4 internal constant ERC4906_INTERFACE_ID = bytes4(0x49064906);

    // Optional mapping for token URIs
    mapping(uint256 tokenId => string) internal _tokenURIs;

    /**
     * @dev See {IERC165-supportsInterface}
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override (ERC721, IERC165) returns (bool) {
        return interfaceId == ERC4906_INTERFACE_ID || super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        _requireOwned(tokenId);

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via string.concat).
        if (bytes(_tokenURI).length > 0) {
            return string.concat(base, _tokenURI);
        }

        return super.tokenURI(tokenId);
    }

    /**
     * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
     *
     * Emits {MetadataUpdate}.
     */
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        _tokenURIs[tokenId] = _tokenURI;
        emit MetadataUpdate(tokenId);
    }

    function _update(address to, uint256 tokenId, address auth) internal virtual override (ERC721) returns (address) {
        return super._update(to, tokenId, auth);
    }
}
