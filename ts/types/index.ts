export type Address = `0x${string}`;
export type Data = Record<string, unknown> & { alloc: number };
