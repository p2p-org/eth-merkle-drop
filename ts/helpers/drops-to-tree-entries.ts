import type { Address, Data } from "../types";

import { ethToWei } from "./eth-to-wei";

export const dropsToTreeEntries = (drops: Record<Address, Data>) =>
  Object.entries(drops).map(([address, { alloc }]) => [
    address,
    ethToWei(alloc),
  ]);
