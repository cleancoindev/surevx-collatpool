pragma solidity ^0.6.0;

import './CollateralPool.sol';

contract SinglePoolCollat {
    address public collateralPool;
    uint public poolId;
    address public poolOwner;
    uint public openBalance;
    uint endDate;

    constructor(address _poolOwner, uint _poolId, uint _endDate) public payable {
        collateralPool = msg.sender;
        poolOwner = _poolOwner;
        poolId = _poolId;
        endDate = _endDate;
    }
    
    receive() payable external {}
    
    
    // function marginCall() - gets collateral from pool

    // Function reverseMarginCall() - returns collateral to pool
    
    // Function unwindCollat() - returns all funds to pool
}