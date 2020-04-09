pragma solidity >=0.5.0 <0.7.0;

interface EIP2362Interface{
  //This is the exposed EIP function that loops through the oracle addresses and medianizes the values
  function valueFor(bytes32 _id) external view returns(int,uint,int);
}
