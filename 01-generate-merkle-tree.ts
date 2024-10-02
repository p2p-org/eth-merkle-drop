// https://github.com/OpenZeppelin/merkle-tree?tab=readme-ov-file#building-a-tree

import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";

async function main() {
    try {
        const values = [
            ["0x1111111111111111111111111111111111111111", "5000000000000000000"],
            ["0x2222222222222222222222222222222222222222", "2500000000000000000"]
        ];

        const tree = StandardMerkleTree.of(values, ["address", "uint256"]);

        console.log('Merkle Root:', tree.root);
        fs.writeFileSync("tree.json", JSON.stringify(tree.dump()));

        console.log('Done.')
    } catch (err) {
        console.log(err)
    }
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
