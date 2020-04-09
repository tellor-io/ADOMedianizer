pragma solidity >=0.5.0 <0.7.0;

contract sampleOracle is EIP236Interface{
  address public owner;
  address public IDMappings;
  address[] public oracles;


  function setValue(bytes32 _id, uint _value){

  }



  //This is the exposed EIP function that loops through the oracle addresses and medianizes the values
  function valueFor(bytes32 _id) public view returns(int,uint,int){
    
  } 
}
