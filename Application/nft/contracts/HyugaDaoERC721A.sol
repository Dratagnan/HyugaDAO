// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

// @author Dratagnan / Draka / https://twitter.com/Dixdraka

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./ERC721A.sol";
import "./ERC721AQueryable.sol";

contract HyugaDaoERC721A is Ownable, ERC721A, ERC721AQueryable, PaymentSplitter {

   using Strings for uint;

   enum Step {
      Before,
      WhitelistSale,
      PublicSale,
      SoldOut,
      Reveal
   }

   Step public settingStep;
   
   uint private constant MAX_SUPPLY = 100;
   uint private constant MAX_GIFT = 5;
   uint private constant MAX_WHITELIST = 50;
   uint private constant MAX_PUBLIC = 45;
   uint private constant MAX_SUPPLY_MINUS_GIFT = MAX_SUPPLY - MAX_GIFT; // nombre max de nft mintable

   uint public wlSalePrice = 0.03 ether;
   uint public publicSalePrice = 0.05 ether;

   uint public saleStartTime = 1660341600; // timestamp a coller

   bytes32 public merkleRoot;

   string public baseURI;

   mapping (address => uint) amountNFTperWalletWhitelistSale;
   mapping (address => uint) amountNFTperWalletPublicSale;

   uint private constant maxPerAddressDuringWhitelistMint = 1;
   uint private constant maxPerAddressDuringPublicMint = 2;

   bool public isPaused;

   uint private teamLength;

   address[] private _team = [
      0xe9Da6dBdB7441E360d441C331851ef1dE35ed195, // a remplacer par les adresses de la team
      0x6361d5b55F8078cB1DE84FBF4b3476A8a0E73e31,
      0x48a3d52243bc1A2b47442C6E517DeDe822E6316c
   ];

   uint[] private _teamShares = [
      700, //mieux de les mettre /1000 pour le partage
      295,
      5
   ];

   // constructor 
   constructor(bytes32 _merkleRoot, string memory _baseURI)
   ERC721A("Hyuga DAO", "HYUGA")
   PaymentSplitter(_team, _teamShares) {
      merkleRoot = _merkleRoot;
      baseURI = _baseURI;
      teamLength = _team.length;
   }

   /** 
   * @notice Allows to set the whitelist sale price
   * 
   * @param _wlSalePrice is the new price 
   */

   function setWlSalePrice(uint _wlSalePrice) external onlyOwner {
      wlSalePrice = _wlSalePrice;
   }

   /** 
   * @notice Allows to set the public sale price
   *
   * @param _publicSalePrice is the new price 
   */

   function setPublicSalePrice(uint _publicSalePrice) external onlyOwner {
      publicSalePrice = _publicSalePrice;
   }

      /** 
   * @notice change the starting time (timestamp) of the wl sale
   *
   * @param _saleStartTime is the new timestamp for the launch of the wl sale
   */

   function setSaleStartTime(uint _saleStartTime) external onlyOwner {
      saleStartTime = _saleStartTime;
   }

      /** 
   * @notice get the actual timestamp
   * 
   * @return the current timestamp
   */

   function currentTime() internal view returns(uint) {
      return block.timestamp;
   }

      /** 
   * @notice change the step of the sale
   * 
   * @param _step new step of the sale 
   */

   function setStep(uint _step) external onlyOwner {
      settingStep = Step(_step);
   }

         /** 
   * @notice pause or restart the smart contract
   * 
   * @param _isPaused true or false is we want to pause 
   */

   function setPaused(bool _isPaused) external onlyOwner {
      isPaused = _isPaused;
   }

         /** 
   * @notice change the baseURI of the NFT
   * 
   * @param _baseURI the new base URI of the NFT 
   */

   function setBaseURI(string memory _baseURI) external onlyOwner {
      baseURI = _baseURI;
   }

         /** 
   * @notice change the merkle root  of the sale
   * 
   * @param _merkleRoot is the new merkle root 
   */

   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
      merkleRoot = _merkleRoot;
   }

   /** 
   * @notice hash an address
   * 
   * @param _account the adress to be hashed
   * 
   * @return bytes32 the hashed address
   */

   function leaf(address _account) internal pure returns(bytes32) {
      return keccak256(abi.encodePacked(_account));
   }

   /** 
   * @notice return true if a leaf can be proved to be a part of a merkle tree definer by root
   * 
   * @param _leaf the leaf
   * @param _proof the merkle proof
   * 
   * @return True if a leaf can be proven to be a part of a merkle
   */

   function _verify(bytes32 _leaf, bytes32[] memory _proof) internal view returns(bool) {
      return MerkleProof.verify(_proof, merkleRoot, _leaf);
   }

   /** 
   * @notice check if an address is whitelisted or not
   * 
   * @param _account the account checked
   * @param _proof the merkle proof
   * 
   * @return bool return true if the address is whitelisted of fals if not
   */

   function isWhitelisted(address _account, bytes32[] calldata _proof) internal view returns(bool) {
      return _verify(leaf(_account), _proof);
   }
}