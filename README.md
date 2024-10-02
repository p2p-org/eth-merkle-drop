## MerkleAirdrop

A merkle tree based contract for airdropping ETH.

### Usage

Use the `01-generate-merkle-tree.ts` script as an example to generate the merkle tree based on

- recipient address
- amount of ETH in wei for that recipient

The script produces a `tree.json` file, which can later be used in a browser to generate for each individual claimer:

- amount of ETH to claim
- merkle proof

The `MerkleAirdrop` contract has a `claim` function, which acceepts these 2 parameters (amount and merkle proof) and can be called by any recipient to get their airdrop.
