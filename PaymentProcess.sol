// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
contract PaymentProcess{
    mapping(address=>uint)public contributors;
    address public manager;
    uint public minContribution;
    uint public deadline;
    uint public targetprice;
    uint public raisedAmt;
    uint public  noOfContributors;
    string public proposal;
    string public officialName;

    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfFVoters;
        mapping(address=>bool)voters;
    }
    mapping (uint=>Request) public requests;
    uint public ReqId;

    enum State {Created, Voting, Ended}
    State public state;


    constructor(string memory _officialName, uint _targetprice,uint _deadline, string memory _proposal){
    officialName=_officialName;
    targetprice=_targetprice;
    deadline=block.timestamp+_deadline; // 10sec+3600sec(60*60)
    minContribution = _targetprice / 100 ;
    manager=msg.sender;
    proposal = _proposal;
    state = State.Created;
    }

    modifier inState(State _state){
    require (state == _state);
    _;
    }

    function fundEth()public payable inState(State.Created){
    require(block.timestamp<deadline,"Deadline has been passed");
    require(msg.value>=minContribution,"Minimum Contribution is not met");
    if(contributors[msg.sender]==0){
        noOfContributors ++;
    }
    contributors[msg.sender]+=msg.value;
    raisedAmt+=msg.value;
    }

    function getTotalBalance() public view inState(State.Created) returns (uint){
        return address(this).balance;
    }

    function refund() public inState(State.Ended){
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

    modifier bySenderOnly(address payable recipient) {
        require(msg.sender != recipient, 'Sender and recipient cannot be the same.');
        _;
    }


    function createRequest(string memory _description, address payable _recipient, uint _value) public byManagerOnly{
        Request storage newRequest = requests[ReqId];
        ReqId++;
        newRequest.description=_description;
        newRequest.recipient=_recipient;
        newRequest.value=_value;
        newRequest.completed=false;
        newRequest.noOfFVoters=0;
    }

    function voteRequest(uint _requestId)public{                            
        require(contributors[msg.sender]>0,"You must be contributor");
        Request storage thisRequest=requests[_requestId];
        require(thisRequest.voters[msg.sender]==false,"You have already voted");
        thisRequest.voters[msg.sender]=true;
        thisRequest.noOfFVoters++;
    }

    function makePayment(uint _requestId)public byManagerOnly{
    require(raisedAmt>=targetprice);
    Request storage thisRequest=requests[_requestId];
    require(thisRequest.completed==false,"The request has been completed");
    require(thisRequest.noOfFVoters > noOfContributors/2,"Majority does not support");
    thisRequest.recipient.transfer(thisRequest.value);
    thisRequest.completed=true;
    }

}