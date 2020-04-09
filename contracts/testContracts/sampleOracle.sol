pragma solidity >=0.5.0 <0.7.0;
import "../EIP2362Interface.sol";

contract sampleOracle is EIP2362Interface{
  mapping(bytes32=>mapping(uint=>int256)) valuesByID;
  mapping (bytes32 => uint[]) timestampsByID;
  

  function setValue(bytes32 _id, int256 _value) external{
  	valuesByID[_id][now] = _value;
  	timestampsByID[_id].push(now);
  }



  //This is the exposed EIP function that loops through the oracle addresses and medianizes the values
  function valueFor(bytes32 _id) external view returns(int _value,uint _timestamp,uint _status){
    _timestamp = timestampsByID[_id][timestampsByID[_id].length - 1];
    if(_timestamp > 0){
    	return(valuesByID[_id][_timestamp],_timestamp,200);
	}
	else return(0,0,404);
  } 
}
