pragma solidity ^0.6.0;

import './CollateralPool.sol';

contract SinglePoolCollat {
    address payable public collateralPoolAddress;
    uint public poolId;
    address public poolOwner;
    uint public currentBalance;
    uint requiredBal;   // Face value required collateral balance
    uint maintenanceBal;   // Actual required collateral balance once haircut is applied
    uint endDate;
    uint haircut;
    bool running = true;

    constructor(address _poolOwner, uint _poolId, uint _requiredBal, uint _endDate, uint _haircut) public payable {
        collateralPoolAddress = msg.sender;
        poolOwner = _poolOwner;
        poolId = _poolId;
        endDate = _endDate;
        require(_requiredBal > 0, 'Required Balance must be greater than 0');
        requiredBal = _requiredBal;
        require(_haircut <= 1, 'Haircut value must be 1 or less');
        haircut = _haircut;
    }
    
    receive() payable external {}
    
    
    // pool events
    event marginCallSuccess(uint amountTransferred, address cpAddress);
    event marginCallFail(uint amountRequested, address cpAddress);

    // INTERNAL FUNCTIONS
    
    // Apply haircut
    function applyHaircut() internal {
        maintenanceBal = requiredBal * (1 + haircut);
    }
    
    // ADMIN FUNCTIONS
    
    // Put the contract on pause (no more margin calls)
    function pause() external isRunning {
        running = false;
    }
    
    
    //MARGIN CALLS & UNWINDING

    // pull ether from the collateral pool (margin call)
    function marginCall(uint amount) external isRunning validAmount(amount) {
        CollateralPool(collateralPoolAddress).marginCall(amount);
        currentBalance += amount;
    
        // emit a success event
        emit marginCallSuccess(amount, collateralPoolAddress);
    }
    
    // put ether back to Pool (reverse margin call)
    function reverseMarginCall(uint256 amount) external isRunning validAmount(amount) {
        collateralPoolAddress.transfer(amount);
        currentBalance -= amount;
    }
    
    // return all funds to pool
    function unwindCollat() external isRunning {
        collateralPoolAddress.transfer(currentBalance);
        currentBalance = 0;
    }
    
    
    
    // MODIFIERS
    
    // check if the ETHER amount is greater than 0
    modifier validAmount(uint amount) {
        require(amount > 0, 'Amount should be greater than zero');
        emit marginCallFail(amount, collateralPoolAddress);
        _;
    }

    // Confirm the contract isn't currently paused
    modifier isRunning() {
        require(running, 'Contract is not currently running');
        _;
    }
    
}