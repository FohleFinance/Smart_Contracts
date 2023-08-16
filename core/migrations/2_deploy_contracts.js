const Factory = artifacts.require("FOHLE_Factory.sol");

module.exports = async function (deployer, network, addresses) {
    await deployer.deploy(Factory, addresses[0]);
    const factory = await Factory.deployed();
};