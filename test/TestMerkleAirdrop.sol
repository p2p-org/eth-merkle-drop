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

    bytes32 root =
        0xb2b6910fa38afa68850d650df636efb1042aab873e1f310a9463e59dbda75f4d;

    Claim[3] claims;

    uint256 TOTAL_ETHER = 1_000_000 ether;

    function setUp() public {
        vm.createSelectFork("mainnet", 20710000);

        deployer = makeAddr("deployer");
        owner = makeAddr("owner");

        claims[0] = Claim({
            claimer: payable(0x1111111111111111111111111111111111111111),
            amount: 5000000000000000000,
            proof: new bytes32[](1)
        });
        claims[0].proof[
                0
            ] = 0xddb676dfe72864e938955c6fbcda77b7461c9fb09d4bcb275191a05170909e6d;

        claims[1] = Claim({
            claimer: payable(0x2222222222222222222222222222222222222222),
            amount: 2500000000000000000,
            proof: new bytes32[](2)
        });
        claims[1].proof[
                0
            ] = 0x9f42d0cdc75d91462576e4b33f13a3c6fa2169f7a146fe244caf55cbe3182e74;
        claims[1].proof[
                1
            ] = 0xeb02c421cfa48976e66dfb29120745909ea3a0f843456c263cf8f1253483e283;

        claims[2] = Claim({
            claimer: payable(0x3333333333333333333333333333333333333333),
            amount: 100500000000000000000000,
            proof: new bytes32[](2)
        });
        claims[2].proof[
                0
            ] = 0xb92c48e9d7abe27fd8dfd6b5dfdbfb1c9a463f80c712b66f3a5180a090cccafc;
        claims[2].proof[
                1
            ] = 0xeb02c421cfa48976e66dfb29120745909ea3a0f843456c263cf8f1253483e283;

        vm.startPrank(deployer);
        merkleAirdrop = new MerkleAirdrop(root);
        vm.stopPrank();

        vm.deal(owner, TOTAL_ETHER);
    }

    function test_Claim() external {
        vm.startPrank(deployer);
        merkleAirdrop.transferOwnership(owner);
        vm.stopPrank();

        vm.startPrank(owner);
        merkleAirdrop.acceptOwnership();
        Address.sendValue(payable(address(merkleAirdrop)), TOTAL_ETHER);
        vm.stopPrank();

        for (uint256 i = 0; i < claims.length; i++) {
            uint256 balanceBefore = claims[i].claimer.balance;

            vm.startPrank(claims[i].claimer);
            merkleAirdrop.claim(claims[i].amount, claims[i].proof);
            vm.stopPrank();

            uint256 balanceAfter = claims[i].claimer.balance;

            assertEq(merkleAirdrop.claimed(claims[i].claimer), true);
            assertEq(balanceAfter - balanceBefore, claims[i].amount);
        }
    }

    function test_SetMerkleRoot() external {
        vm.startPrank(deployer);
        merkleAirdrop.transferOwnership(owner);
        vm.stopPrank();

        vm.startPrank(owner);
        merkleAirdrop.acceptOwnership();

        vm.expectRevert(MerkleAirdrop__SameRoot.selector);
        merkleAirdrop.setMerkleRoot(root);

        merkleAirdrop.setMerkleRoot(bytes32(uint256(42)));
        vm.stopPrank();
    }
}

struct Claim {
    address payable claimer;
    uint256 amount;
    bytes32[] proof;
}
