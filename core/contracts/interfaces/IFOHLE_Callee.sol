pragma solidity >=0.5.0;

interface IFOHLE_Callee {
    function FOHLE_Call(address sender, uint256 amount0, uint256 amount1, bytes calldata data) external;
}