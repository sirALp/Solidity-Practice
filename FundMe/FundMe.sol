// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error notOwner();

contract FundMe{

    receive() external payable {
        fund();
    }
    fallback() external payable {
        fund();
    }

    using PriceConverter for uint256;

    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    uint256 public constant MINIMUM_USD = 50*1e18;

    address[] public funders;

    mapping(address => uint256) public addressToFundAmount;

    function fund() public payable{
        require(msg.value.getConversionRate() >= MINIMUM_USD,"Didn't send enough!");
        funders.push(msg.sender);
        addressToFundAmount[msg.sender] = addressToFundAmount[msg.sender] + msg.value.getConversionRate();
    }
    
    function withdraw() public onlyOwner{
        for(uint256 funderIndex = 0; funderIndex < funders.length;funderIndex++)
            addressToFundAmount[funders[funderIndex]] = 0; // setting every funder's fund to 0
        
        funders = new address[](0); // refreshing funders array
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"Call failed"); // transfering tokens from contract to owner via call func
    }
    
    modifier onlyOwner{
        //require(msg.sender == i_owner,"No permisson !");
        if(msg.sender != i_owner)
            revert notOwner();
        _;
    }

}