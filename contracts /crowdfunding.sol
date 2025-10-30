// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Crowdfunding {
    address public owner;
    uint256 public goal;
    uint256 public totalFunds;
    mapping(address => uint256) public contributions;

    constructor(uint256 _goal) {
        owner = msg.sender;
        goal = _goal;
    }

    // Function 1: Contribute to the crowdfunding goal
    function contribute() external payable {
        require(msg.value > 0, "Contribution must be greater than 0");
        require(totalFunds < goal, "Funding goal already reached");

        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
    }

    // Function 2: Withdraw funds (only if goal is reached)
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalFunds >= goal, "Funding goal not yet reached");

        payable(owner).transfer(address(this).balance);
    }

    // Optional Function 3: View current balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

