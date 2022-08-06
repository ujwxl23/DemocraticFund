// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
contract PaymentProcess{
    mapping(address=>uint)public contributors;
    address public manager;
    uint public minContribution;
    uint public deadline;
    uint public targetprice;
    uint public raisedAmt;
    uint public  no0fContributors;

    constructor(uint _targetprice,uint _deadline){
    targetprice=_targetprice;
    deadline=block.timestamp+_deadline; // 10sec+3600sec(60*60)
    minContribution=100 wei;
    manager=msg.sender;
    }
    
    function fundEth()public payable{
    require(block.timestamp<deadline,"Deadline has been passed");
    require(msg.value>=minContribution,"Minimum Contribution is not met");
    if(contributors[msg.sender]==0){
        no0fContributors ++;
    }
    contributors[msg.sender]+=msg.value;
    raisedAmt+=msg.value;
    }

    function getTotalBalance() public view returns (uint){
        return address(this).balance;
    }

    function refund() public{
        require(block.timestamp>deadline && raisedAmt<targetprice, "you are not eligible for refund");
        require(contributors[msg.sender]>0);
        address payable user= payable (msg.sender);
        user.transfer(contributors[msg.sender]);
    }

}