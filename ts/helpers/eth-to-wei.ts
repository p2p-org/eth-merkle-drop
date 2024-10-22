export const ethToWei = (eth: string | number): string => {
  // Convert input to string and handle scientific notation
  const ethString = eth.toString();

  // Handle decimal points
  let [whole, decimal] = ethString.split(".");
  decimal = decimal || "0";

  // Pad with zeros or truncate to 18 decimal places
  decimal = decimal.padEnd(18, "0").slice(0, 18);

  // Remove leading zeros from whole number
  whole = whole.replace(/^0+/, "") || "0";

  // Combine whole and decimal parts
  return whole + decimal;
};
