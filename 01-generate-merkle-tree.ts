// https://github.com/OpenZeppelin/merkle-tree?tab=readme-ov-file#building-a-tree

import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";
import "dotenv/config";

import { Address, Data } from "./ts/types";
import { dropsToTreeEntries } from "./ts/helpers/drops-to-tree-entries";

async function main() {
  try {
    const tree = StandardMerkleTree.of(
      dropsToTreeEntries(loadDrops(process.env.DROP_SOURCE!)),
      ["address", "uint256"]
    );

    console.log("Merkle Root:", tree.root);
    fs.writeFileSync("tree.json", JSON.stringify(tree.dump()));

    for (const [i, v] of tree.entries()) {
      console.log("Claimer:", v[0]);
      console.log("Amount:", v[1]);
      console.log("Proof:", tree.getProof(i));
    }

    console.log("Done.");
  } catch (err) {
    console.log(err);
  }
}

const loadDrops = (path: string): Record<Address, Data> =>
  JSON.parse(fs.readFileSync(path, "utf8"));

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
