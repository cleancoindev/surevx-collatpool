pragma solidity ^0.6.0;

import './CollateralPool.sol';

contract SinglePoolCollat {
    address payable public collateralPoolAddress;
    uint public poolId;
    address public poolOwner;
    uint public currentBalance;
    uint endDate;

    constructor(address _poolOwner, uint _poolId, uint _endDate) public payable {
        collateralPoolAddress = msg.sender;
        poolOwner = _poolOwner;
        poolId = _poolId;
        endDate = _endDate;
    }
    
    receive() payable external {}
    
    
    // pool events
    event marginCallSuccess(uint amountTransferred, address cpAddress);
    event marginCallFail(uint amountRequested, address cpAddress);

    // pull ether from the collateral pool
    function marginCall(uint amount) external validAmount(amount) {
        CollateralPool(collateralPoolAddress).marginCall(amount); 
        currentBalance += amount;
        
        // emit a success event
        emit marginCallSuccess(amount, collateralPoolAddress);
    }
    
    // reverse a margin call
    function reverseMarginCall(uint256 amount) external validAmount(amount) {
        collateralPoolAddress.transfer(amount);
        currentBalance -= amount;
    }
    
    // return all funds to pool
    function unwindCollat() external {
        collateralPoolAddress.transfer(currentBalance);
        currentBalance = 0;
    }
    
    // check if the ETHER amount is greater than 0
    modifier validAmount(uint amount) {
        require(amount > 0, 'Amount should be greater than zero');
        emit marginCallFail(amount, collateralPoolAddress);
        _;
    }
    
}