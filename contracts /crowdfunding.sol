// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Crowdfunding {
    address public owner;
    uint256 public goal;
    uint256 public totalFunds;
    bool public goalReached;
    bool public goalFailed;
    mapping(address => uint256) public contributions;

    constructor(uint256 _goal) {
        owner = msg.sender;
        goal = _goal;
    }

    // Function 1: Contribute to the crowdfunding goal
    function contribute() external payable {
        require(msg.value > 0, "Contribution must be greater than 0");
        require(!goalReached, "Funding goal already reached");
        require(!goalFailed, "Campaign ended");

        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;

        if (totalFunds >= goal) {
            goalReached = true;
        }
    }

    // Function 2: Withdraw funds (only owner)
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(goalReached, "Goal not reached yet");

        payable(owner).transfer(address(this).balance);
    }

    // Function 3: View contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Function 4: Refund contributors if goal not reached
    function refund() external {
        require(!goalReached, "Goal was reached, cannot refund");
        uint256 contributed = contributions[msg.sender];
        require(contributed > 0, "No contributions to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(contributed);
    }

    // Function 5: Get individual contributor’s amount
    function getContributorAmount(address contributor) external view returns (uint256) {
        return contributions[contributor];
    }
}
