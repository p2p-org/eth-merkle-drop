// SPDX-FileCopyrightText: 2024 P2P Validator <info@p2p.org>
// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";
import "../src/MerkleAirdrop.sol";

contract TestMerkleAirdrop is Test {
    MerkleAirdrop merkleAirdrop;

    address deployer;
    address owner;
    address claimer;

    function setUp() public {
        vm.createSelectFork("mainnet", 20710000);

        deployer = makeAddr("deployer");
        owner = makeAddr("owner");
        claimer = makeAddr("claimer");

        merkleAirdrop = new MerkleAirdrop(bytes32(0));
    }

    function test_42() external {

    }
}
