pragma solidity ^0.5.0;

import "./EIP2362Interface.sol";

/**
* @title ADOMedianizer
* @notice This contract allows the owner to specify multiple oracles
* to use for collecting data and ultimately calculating the median of these
*/

contract ADOMedianizer is EIP2362Interface{
    /*Variables*/ 
    address public owner;
    address[] public oracles;
    mapping(address => uint256) public oraclesIndex;

  
    constructor() public {
        owner = msg.sender;
        oracles.push(address(0));
    }


    modifier restricted() {
        if (msg.sender == owner) _;
    }

    /*Functions*/
    /**
    * @dev allows owner to transfer ownership
    * @param _newOwner is the address ownership is being transferred to
    */
    function changeOwner(address _newOwner) restricted() external{
        owner = _newOwner;
    }

    /**
    * @dev This function loops through the oracle addresses and medianizes the values
    * @param _id the standardized ADO data type/value pair id
    * @return median value, timestamp and status
    */
    function valueFor(bytes32 _id) external view returns(int256,uint256,uint256){
        if(oracles.length >= 2){
          int256[] memory values = new int256[](oracles.length-1);
          int256 val;
          uint256 time;
          uint256 status;
          uint256 len = 0; 
          for(uint256 pos = 1; pos < oracles.length;pos++){
             (val,time,status) = EIP2362Interface(oracles[pos]).valueFor(_id);
                if(status == 200){
                    values[len] = val;
                    len++;
                }
          }
          if(len > 0){
            return (median(values,len),now,200);
          }
          else{
            return(0,0,400);
          }
        }
        return(0,0,404);
  } 

    /**
    * @dev Allows owner to add an oracle provider
    * @param _oracle is the oracle address for the oracle being added
    */
    function addOracle(address _oracle) restricted() external{
        oraclesIndex[_oracle] = oracles.length;
        oracles.push(_oracle);
    }


    /**
    * @dev Allows the owner to remove an oracle provider
    * @param _oracle is the oracle address for the oracle being excluded
    */
    function removeOracle(address _oracle) restricted() external{
        uint256 index = oraclesIndex[_oracle];
        if(index != oracles.length-1){
            address last = oracles[oracles.length - 1];
            oracles[index] = last;
        }
        oracles.pop();
        oraclesIndex[_oracle] = 0;
    }

    /**
    * @dev Getter returning an array of all oracles in this contract
    * Note: the 0 slot is filled with the 0 address
    */
    function getOracles() external view returns(address[] memory _oracles){
      return oracles;
    }

    /**
    * @dev Internal function that sorts values submitted by oracles and returns the median
    * @param a is the array containing the values submitted for the Id by all the oracles
    * @return median value
    */
    function median(int256[] memory a, uint256 len) internal pure returns(int256){
        for (uint256 i = 1; i < len; i++) {
            int256 temp = a[i];
            uint256 j = i;
            while (j > 0 && temp < a[j - 1]) {
                a[j] = a[j - 1];
                j--;
            }
            if (j < i) {
                a[j]= temp;
            }
        }
        uint256 m = len/2;
        return(a[m]);
    }

}
