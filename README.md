# MultipleSecripts
# Payment Splitter Smart Contract

## Overview
The **Payment Splitter** is a Solidity smart contract that allows multiple recipients to receive payments in a predefined ratio. This contract ensures that funds are automatically distributed among recipients based on their respective shares whenever Ether is received. Recipients can withdraw their accumulated balances at any time.

## Features
- Accepts Ether payments.
- Splits and stores funds based on predefined shares.
- Allows recipients to withdraw their allocated funds.
- Provides read functions to check balances and shares.

---

## Deployment Instructions
### Prerequisites
Before deploying the contract, ensure you have:
- **Remix IDE** or a Solidity-compatible development environment.
- **MetaMask** or a Web3 provider connected to an Ethereum testnet/mainnet.
- **Solidity compiler (0.8.0 or later).**

### Steps to Deploy
1. **Clone the Repository**
   ```sh
   git clone https://github.com/yourusername/payment-splitter.git
   cd payment-splitter
   ```

2. **Open Remix IDE**
   - Go to [Remix IDE](https://remix.ethereum.org/).
   - Create a new Solidity file (e.g., `PaymentSplitter.sol`).
   
3. **Copy & Paste the Contract Code**
   - Insert the Solidity smart contract into the newly created file.

4. **Compile the Contract**
   - Select the Solidity compiler version `0.8.0` or later.
   - Click **Compile PaymentSplitter.sol**.

5. **Deploy the Contract**
   - Under the "Deploy & Run Transactions" tab:
   - Select **Injected Web3** as the environment if using MetaMask.
   - Enter constructor arguments:
     - `_recipients`: Array of Ethereum addresses.
     - `_shares`: Array of share values corresponding to recipients.
   - Click **Deploy**.

6. **Interact with the Contract**
   - Use the contract functions to send Ether and manage balances.

---

## Smart Contract Code with adress - 
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentSplitter {
    address[] private recipients;
    uint256[] private shares;
    mapping(address => uint256) private balances;
    uint256 private totalShares;

    constructor(address[] memory _recipients, uint256[] memory _shares) {
        require(_recipients.length == _shares.length, "Mismatched inputs");
        require(_recipients.length > 0, "No recipients provided");

        for (uint256 i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0), "Invalid recipient address");
            require(_shares[i] > 0, "Shares must be greater than zero");

            recipients.push(_recipients[i]);
            shares.push(_shares[i]);
            totalShares += _shares[i];
        }
    }

    receive() external payable {
        require(msg.value > 0, "No ether sent");
        uint256 amount = msg.value;

        for (uint256 i = 0; i < recipients.length; i++) {
            uint256 recipientShare = (amount * shares[i]) / totalShares;
            balances[recipients[i]] += recipientShare;
        }
    }

    function withdraw() external {
        uint256 payment = balances[msg.sender];
        require(payment > 0, "No funds available");

        balances[msg.sender] = 0;
        payable(msg.sender).transfer(payment);
    }

    function getRecipientShare(address recipient) external view returns (uint256) {
        for (uint256 i = 0; i < recipients.length; i++) {
            if (recipients[i] == recipient) {
                return shares[i];
            }
        }
        return 0;
    }

    function getBalance(address recipient) external view returns (uint256) {
        return balances[recipient];
    }

    function totalSharesCount() external view returns (uint256) {
        return totalShares;
    }
}
```

---

## Functions Explained

### 1. Constructor
```solidity
constructor(address[] memory _recipients, uint256[] memory _shares)
```
- Initializes the contract with recipients and their respective shares.
- Ensures inputs are valid and calculates total shares.

### 2. Receive Ether
```solidity
receive() external payable
```
- Automatically splits received Ether among recipients based on their share percentage.

### 3. Withdraw Funds
```solidity
function withdraw() external
```
- Allows a recipient to withdraw their allocated balance.

### 4. Get Share of a Recipient
```solidity
function getRecipientShare(address recipient) external view returns (uint256)
```
- Returns the share of a given recipient.

### 5. Get Recipient Balance
```solidity
function getBalance(address recipient) external view returns (uint256)
```
- Returns the pending balance for a recipient.

### 6. Get Total Shares
```solidity
function totalSharesCount() external view returns (uint256)
```
- Returns the total number of shares in the contract.

---

## Usage Guide
### Sending Payments
1. Send Ether directly to the contract address.
2. Funds will be distributed among recipients automatically.

### Withdrawing Funds
1. A recipient calls the `withdraw()` function.
2. The recipient receives their pending balance.

---

## Security Considerations
- **No external imports**: Keeps the contract lightweight and secure.
- **Reentrancy Safe**: State variables are updated before transfers to prevent attacks.
- **Validations in place**: Ensures proper input and prevents invalid recipient addresses.

---

## License
This project is licensed under the **MIT License**.

---

## Future Enhancements
- Support for ERC20 token payments.
- Upgradeable contract version using a proxy pattern.
- Automatic withdrawals instead of manual `withdraw()` calls.

---

## Conclusion
The **Payment Splitter Smart Contract** is a simple yet powerful way to distribute payments among multiple recipients efficiently. It ensures transparency, fairness, and automation in handling multi-recipient payouts.

🚀 **Deploy & Start Splitting Payments Seamlessly!**

