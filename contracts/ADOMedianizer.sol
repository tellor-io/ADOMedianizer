pragma solidity >=0.5.0 <0.7.0;

import "./EIP2362Interface.sol";
import "./SafeMath.sol";

contract ADOMedianizer is EIP2362Interface{
    /*Variables*/ 
    address public owner;
    address[] public oracles;
    mapping(address => uint) public oraclesIndex;

  
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
    * @param _id the standarized ADO data type/value pair id
    * @return median, timestamp and status
    */
    function valueFor(bytes32 _id) external view returns(int,uint,uint){
        //make sure the array is not empty
        //should there be a minimum values avaialbe?--this basically makes i
        // a requirement to include at leas x amount of oracles, in this example: 3 
        require(oracles.length-1 > 1, "No values available for this Id");
        int[] memory values;
        int val;
        uint time;
        uint status;
        uint len = 0;
        uint num = oracles.length-1;
        for(uint i = 1; i<num ;i++){
           (val,time,status) = EIP2362Interface(oracles[i]).valueFor(_id);
              if(status == 200){
                  values[len] = val;
                  len++;
              }
        }
        return (median(values),now,200);
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
        uint index = oraclesIndex[_oracle];
        // just add the -1???
        if(index != oracles.length-1){
            address last = oracles[oracles.length - 1];
            oracles[index] = last;
        }
        oracles.length--;
        oraclesIndex[_oracle] = 0;
    }


    /**
    * @dev Internal function that sorts values submitted by oracles and returns the median
    * @param a is the array containing the values submitted for the Id by all the oracles
    * @return median value
    */
    function median(int256[] memory a) internal view returns(int){
        uint256 i;
        for (i = 1; i < a.length; i++) {
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
        uint256 m = a.length/2;
        returns(a[m]);
    }

}
