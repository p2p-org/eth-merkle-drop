pragma solidity 0.8.27;

import "./@openzeppelin/access/Ownable2Step.sol";
import "./@openzeppelin/utils/cryptography/MerkleProof.sol";
import "./@openzeppelin/utils/Address.sol";

error MerkleAirdrop__AlreadyClaimed();
error MerkleAirdrop__InvalidProof();

contract MerkleAirdrop is Ownable2Step {
    bytes32 public merkleRoot;
    mapping(address => bool) public claimed;

    event MerkleAirdrop__MerkleRootSet(bytes32 _merkleRoot);
    event MerkleAirdrop__EtherRecovered(address _recipient, uint256 _amount);

    constructor(bytes32 _merkleRoot) payable {
        merkleRoot = _merkleRoot;
        emit MerkleAirdrop__MerkleRootSet(_merkleRoot);
    }

    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
        emit MerkleAirdrop__MerkleRootSet(_merkleRoot);
    }

    function claim(uint256 _amount, bytes32[] calldata _merkleProof) external {
        require(!claimed[msg.sender], MerkleAirdrop__AlreadyClaimed());

        // Compute the leaf node
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender, _amount))));

        // Verify the Merkle proof
        require(
            MerkleProof.verify(_merkleProof, merkleRoot, leaf),
            MerkleAirdrop__InvalidProof()
        );

        // Mark address as claimed and transfer the ETH
        claimed[msg.sender] = true;
        Address.sendValue(payable(msg.sender), _amount);
    }

    function recoverEther(address payable _recipient) external onlyOwner {
        emit MerkleAirdrop__EtherRecovered(_recipient, address(this).balance);
        Address.sendValue(_recipient, address(this).balance);
    }

    // Function to allow the contract to receive ETH
    receive() external payable {}
}