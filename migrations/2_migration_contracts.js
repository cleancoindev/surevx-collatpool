const CollatPoolRegister = artifacts.require("CollatPoolRegister");
const CollateralPool = artifacts.require("CollateralPool");
const SinglePoolCollat = artifacts.require("SinglePoolCollat");


module.exports = function(deployer, _network, accounts) {
  deployer.deploy(CollatPoolRegister);
  deployer.deploy(CollateralPool, 0,accounts[0],1000);
  deployer.deploy(SinglePoolCollat, accounts[0],0);
};
