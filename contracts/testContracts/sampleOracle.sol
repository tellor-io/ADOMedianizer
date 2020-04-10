pragma solidity ^0.5.0;
import "../EIP2362Interface.sol";

/**
* @title sampleOracle
* 
*/

contract sampleOracle is EIP2362Interface{
    /*Variables*/
    mapping(bytes32=>mapping(uint=>int256)) valuesByID;
    mapping (bytes32 => uint[]) timestampsByID;
  
    /**
    * @dev Allows oracle provider to push the vlue for the corresponding _id
    * @param _id is the standarized ADO data type/value pair Id
    * @param _value is the value 
    */
    function setValue(bytes32 _id, int256 _value) external{
      	valuesByID[_id][now] = _value;
      	timestampsByID[_id].push(now);
    }

    /**
    * @dev Allows the ADOMedianizer to retreive the value, timestamp, and status for the specifed Id
    * @param _id is the standarized ADO data type/value pair id
    * @return _value the value corresponding to the id
    * @return _timestamp is the unix timestamp
    * @return _status is the standarized data status
    */
    function valueFor(bytes32 _id) external view returns(int _value,uint _timestamp,uint _status){
        _timestamp = timestampsByID[_id][timestampsByID[_id].length - 1];
        if(_timestamp > 0){
           	return(valuesByID[_id][_timestamp],_timestamp,200);
	      }
	      else return(0,0,404);
    } 
}
