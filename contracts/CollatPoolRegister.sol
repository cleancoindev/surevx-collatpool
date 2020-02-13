pragma solidity ^0.6.0;

import './CollateralPool.sol';

contract CollateralPoolRegister {
    uint public lastPoolId;
    mapping (uint => address) public poolOwners;
    mapping (uint => address) public pools;


    constructor() public {}

    function createNewPool(uint duration, string memory exposureLayer) public payable returns(address) {
        lastPoolId++;
        CollateralPool newPool = new CollateralPool(lastPoolId, msg.sender, duration, exposureLayer);
        pools[lastPoolId] = address(newPool);
        poolOwners[lastPoolId] = msg.sender;
        return (address(newPool));    }
}







