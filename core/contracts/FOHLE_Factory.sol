pragma solidity =0.5.16; 

import './interfaces/IFOHLE_Factory.sol';
import './FOHLE_Pair.sol';

contract FOHLE_Factory is IFOHLE_Factory {
    address public feeTo;
    address public setter;
    bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(FOHLE_Pair).creationCode));

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint256);

    constructor(address _setter) public {
        setter = _setter;
    }

    function allPairsLength() external view returns (uint256) {
        return allPairs.length;
    }

    function get30daysPR(uint256 _pair) external view returns (uint256) {
        return IFOHLE_Pair(allPairs[_pair]).days30PR();
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(msg.sender == setter, 'FOHLE: FORBIDDEN');
        require(tokenA != tokenB, 'FOHLE: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'FOHLE: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'FOHLE: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(FOHLE_Pair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IFOHLE_Pair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == setter, 'FOHLE: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setSetter(address _setter) external {
        require(msg.sender == setter, 'FOHLE: FORBIDDEN');
        setter = _setter;
    }

    function set30daysPR(uint256 _pair, uint256 _30daysPR) external {
        require(msg.sender == setter && _pair < allPairs.length, 'FOHLE: FORBIDDEN');
        IFOHLE_Pair(allPairs[_pair]).updateDays30PR(_30daysPR);
    }
}