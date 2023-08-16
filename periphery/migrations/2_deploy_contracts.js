//const Router01 = artifacts.require("FOHLE_Router01.sol");
//const Router02 = artifacts.require("FOHLE_Router02.sol");
const SwapToPrice = artifacts.require("SwapToPrice.sol");
const WETH = artifacts.require("WETH.sol");

module.exports = async function (deployer, network) {
    let weth;
    const FACTORY_ADDRESS = '0x97015F97077B839c740A5296e0bF7eaBfc7345c4'
    const ROUTER02_ADDRESS = '0xC4404A3167874C5656807e0CF0743875FcF675bF'

    if (network === 'ethereum') {
        weth = await WETH.at('0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2');
    } else if (network === 'goerli') {
        weth = await WETH.at('0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6');
    } else if (network === 'sepolia') {
        weth = await WETH.at('0xF30A58331EADeC82Edbb116EC7bd5fDe0B29861E');
    } else {
        await deployer.deploy(WETH);
        weth = await WETH.deployed();
    }

    //await deployer.deploy(Router01, FACTORY_ADDRESS, weth.address);
    //await deployer.deploy(Router02, FACTORY_ADDRESS, weth.address);
    await deployer.deploy(SwapToPrice, FACTORY_ADDRESS, ROUTER02_ADDRESS);
};