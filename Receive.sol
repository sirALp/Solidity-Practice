// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Receive {
    uint256 public testNum = 0;

    receive() external payable{
        testNum++;
    }


}