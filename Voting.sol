// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

error notOwner();
error cannotVote();
error cannotFindCandidate();
contract Voting{

    address immutable owner;
    constructor(){
        owner = msg.sender;
    }

    uint8 public candidateCounter=0; 

    event Voted(uint time,address voter,string votedCandidate);
    event CandidateAdded(uint8 candidateNo,string name,uint32 age);


    struct Voter{
        string _name;
        uint32 _age;
        address _address;
    }
    Voter[] public voters;
    
    struct Candidate{
        uint8 _candidateNo;
        uint256 _voteCounter;
        string _name;
        uint32 _age;
    }
    Candidate[] public candidates;

    function Vote(string memory name,uint32 age,uint32 candidateNo) public {
        uint256 index;
        for (index =0; index < voters.length;index++)
            if(voters[index]._address == msg.sender) revert cannotVote(); 
        
        for (index =0; index < candidates.length;index++)
            if(candidates[index]._candidateNo == candidateNo) break;
        if (index == candidates.length) revert cannotFindCandidate();
        else candidates[index]._voteCounter++;
        voters.push(Voter({_name:name,_age:age,_address:msg.sender}));
        emit Voted(block.timestamp,msg.sender,candidates[candidateNo]._name);
    }

    function addCandidate(string memory name,uint32 age) public onlyOwner{
        candidates.push(Candidate({_candidateNo:candidateCounter,_voteCounter:0,_name:name,_age:age}));
        candidateCounter++;
        emit CandidateAdded(candidateCounter-1,name,age);
    }
    function removeLastCandidate() public onlyOwner{
        candidates.pop();
    }
    function removeIndexedCandidate(uint256 index) public onlyOwner{
        delete candidates[index];
        for (uint256 i=index;i<candidates.length;i++)
            candidates[i] = candidates[i+1];
        // candidates.pop();  can be modified as candidates.length-1 and add this line
    }

    



    modifier onlyOwner(){
        if(msg.sender != owner) revert notOwner();
        _;
    }


}