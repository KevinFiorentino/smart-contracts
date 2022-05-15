// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract FundProject {

    uint goal;
    uint totalFunded;
    bool isFundable;
    address payable owner;

    constructor() {
        goal = 0;                           // 1 ETH = 1^18 = 1000000000000000000
        owner = payable(msg.sender);
        totalFunded = 0;
        isFundable = true;
    }

    modifier onlyOwner {
        require(
            msg.sender == owner,
            "You need to be the owner from this contract to change the goal."
        );
        _;
    }

    modifier notIsOwner {
        require(
            msg.sender != owner,
            "The project owner can not add founds to the project."
        );
        _;
    }

    modifier hasGoal() {
        require(
            goal > 0,
            "The project doesn't have a goal yet."
        );
        _;
    }

    modifier projectAvailable() {
        require(
            isFundable == true,
            "The project is closed."
        );
        _;
    }

    function setGoal(uint g) public onlyOwner {
        goal = g;
    }

    function viewGoal() public view hasGoal returns(uint256) {
        return goal;
    }

    function viewRemaining() public view hasGoal returns(uint256) {
        return goal - totalFunded;
    }

    function changeStatusProject() public onlyOwner {
        isFundable = !isFundable;
    }

    function addFounds() public hasGoal notIsOwner payable projectAvailable {
        owner.transfer(msg.value);
        totalFunded += msg.value;

        // Close project automatically
        if (totalFunded >= goal)
            isFundable = false;
    }

}