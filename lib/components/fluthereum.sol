// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

contract Fluthereum {
    int public balance;
    string public title;
    
    constructor() {
        balance = 0;
        title = "Write here";
    }
    
    function getBalance() view public returns(int) {return balance;}
    
    function getTitle() view public returns (string memory) {return title;}

    function write (string memory text) public { title = text; }

    function deposit(int amount) public {
        balance += amount;
    }
    
    function withdraw(int amount) public {
        balance -= amount;
    }
}