// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract  crowdFunding {
    address public owner;
    uint256 public fundingGoal;
    uint256 public totalFunds;
    bool public goalReached;

    mapping(address => uint256) public contributions;

    event ContributionReceived(address contributor, uint256 amount);
    event GoalReached(uint256 totalFunds);
    event FundsWithdrawn(address owner, uint256 amount);

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the campaign owner can call this function."
        );
        _;
    }

    constructor(uint256 _fundingGoal) {
        owner = msg.sender;
        fundingGoal = _fundingGoal;
        goalReached = false;
    }

    function contribute() external payable {
        require(!goalReached, "Funding goal already reached.");
        require(msg.value > 0, "Contribution must be greater than 0.");

        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;

        emit ContributionReceived(msg.sender, msg.value);

        if (totalFunds >= fundingGoal) {
            goalReached = true;
            emit GoalReached(totalFunds);
        }
    }

    function withdrawFunds() external onlyOwner {
        require(goalReached, "Funding goal not yet reached.");
        require(totalFunds > 0, "No funds to withdraw.");

        uint256 amount = totalFunds;
        totalFunds = 0;

        (bool success, ) = owner.call{value: amount}("");
        require(success, "Transfer failed.");

        emit FundsWithdrawn(owner, amount);
    }
}
