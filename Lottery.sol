// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;



contract Lottery{
    receive() external payable {
        enterLottery();
    }
    fallback() external payable {
        enterLottery();
    }
 
    address immutable public owner;
    address payable []  public players;
    uint256 public lottery_id;
    mapping(uint256 => address) lottery_history;
    
    function listPlayers() public view returns(address[] memory _players){
        return _players;
    }
    
    constructor(){
        owner = msg.sender;
        lottery_id = 1;
    }
    
    function enterLottery() public payable{
        require(msg.value >= .001 ether,"Insufficent ether");
        //payable(msg.sender).transfer(address(this).balance);
        players.push (payable(msg.sender));
    }


    // !!!not a convenient way to generate random number considering more advanced applications 
    function getRandomNumber()internal view returns(uint256){
        return uint256(keccak256(abi.encode(owner,block.timestamp,players.length)));
    }

    function pickWinner() public payable onlyOwner{
        require(players.length>1,"There's no players my mate.");
        uint256 winner_index = getRandomNumber() % 6;

        uint256 amount = address(this).balance;
        address payable winner = players[winner_index];
        winner.transfer(amount);
        
        lottery_history[lottery_id] = winner;
        lottery_id++;

        delete players;
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"You have no permisson!");
        _;
    }

}
