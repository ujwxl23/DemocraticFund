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

    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint no0fFVoters;
        uint noOfNVoters;
        mapping(address=>bool)voters;
    }
    mapping (uint=>Request) public requests;
    uint public numReq;


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
        contributors[msg.sender]=0;
    }

    modifier byManagerOnly(){
        require(msg.sender==manager,"Manager function only");
        _;
    }

    function createRequest(string memory _description, address payable _recipient, uint _value) public byManagerOnly{
        Request storage newRequest = requests[numReq];
        numReq ++;
        newRequest.description=_description;
        newRequest.recipient=_recipient;
        newRequest.value=_value;
        newRequest.completed=false;
        newRequest.no0fFVoters=0;
        newRequest.noOfNVoters=0;
    }

}