pragma solidity ^0.6.0;

import './SinglePoolCollat.sol';

contract CollateralPool {
    uint public poolId;
    uint public startingBalance;
    uint public currentBalance;
    address payable public poolOwner;
    address payable public linkedCollat;
    uint public creationTime;
    uint public endDate;
    enum Status { OPEN, CLOSED }
    Status poolStatus;
    string public exposureLayer = 'NoRef';


    constructor(uint _poolId, address payable _poolOwner, uint _duration, string memory _exposureLayer) public payable {
        poolId = _poolId;
        poolOwner = _poolOwner;
        creationTime = now;
        endDate = creationTime + _duration;
        exposureLayer = _exposureLayer;
        startingBalance = 0;
        currentBalance = 0;
        SinglePoolCollat newCollat = new SinglePoolCollat(poolOwner, poolId, endDate);
        linkedCollat = address(newCollat);
        poolStatus = Status.OPEN;
    }


    //Adding funds
    function topUpPool() public payable {
        currentBalance += msg.value;
    }
    
    function fundPool() external payable {
        startingBalance += msg.value;
        currentBalance += msg.value;
    }
    
    
    //Margin calls 
    function marginCall(uint amount) public onlyLinkedCollat {
        linkedCollat.transfer(amount);
    }
    
    //Closing out
    function withdraw(uint _amount) public onlyOwner isOpen {
        poolOwner.transfer(_amount);
        poolStatus = Status.CLOSED;
    }
    
    function closeCollat() public onlyOwner isFinished {
        poolOwner.transfer(address(this).balance);
    }

    
    modifier onlyOwner {
        require(msg.sender == poolOwner, 'only pool owner can do this');
        _;
    }
    
    modifier isFinished {
        require(now > endDate, 'end date not yet reached');
        _;
    }
    
    modifier isOpen {
        require(poolStatus == Status.OPEN, 'pool is closed');
        _;
    }
    
    modifier onlyLinkedCollat {
        require(msg.sender == linkedCollat, 'only linked collateral deals can do this');
        _;
    }
}