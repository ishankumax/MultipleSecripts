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

