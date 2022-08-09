// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

// @author Dratagnan / Draka / https://twitter.com/Dixdraka

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import "openzeppelin/contracts/utils/Strings.sol";
import "./ERC721A.sol";
import "./ERC721AQueryable.sol";

contract HyugaDaoERC721A is Ownable, ERC721A, ERC721AQueryable, PaymentSplitter {

}