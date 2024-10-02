// SPDX-FileCopyrightText: 2024 P2P Validator <info@p2p.org>
// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import {Script} from "forge-std/Script.sol";
import "../src/MerkleAirdrop.sol";

contract Deploy is Script {
    function run()
        external
        returns (MerkleAirdrop merkleAirdrop)
    {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerKey);
        merkleAirdrop = new MerkleAirdrop(bytes32(0));
        vm.stopBroadcast();

        return merkleAirdrop;
    }
}
