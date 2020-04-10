pragma solidity >=0.5.0 <0.7.0;
import "./EIP2362Interface.sol";
import "./SafeMath.sol";

contract ADOMedianizer is EIP2362Interface{
    /*Variables*/ 
    address public owner;
    address[] public oracles;
    mapping(address => uint) index;

  
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
    function changeOwner(address _newOwner) restricted() public{
        owner = _newOwner;
    }

    /**
    * @dev This function loops through the oracle addresses and medianizes the values
    * @param _id the standarized ADO data type/value pair id
    * @return median, timestamp and status
    */
    function valueFor(bytes32 _id) external view returns(int,uint,uint){
        int[] memory values;
        int _val;
        uint _time;
        uint _status;
        uint len = 0;
        for(uint i = 0; i< oracles.length;i++){
           (_val,_time,_status) = EIP2362Interface(oracles[i]).valueFor(_id);
              if(_status == 200){
                  values[len] = _val;
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
        index[_oracle] = oracles.length;
        oracles.push(_oracle);
    }


    /**
    * @dev Allows the owner to remove an oracle provider
    * @param _oracle is the oracle address for the oracle being excluded
    */
    function removeOracle(address _oracle) restricted() external{
        uint _index = index[_oracle];
        if(_index != oracles.length){
            address last = oracles[oracles.length - 1];
            oracles[_index] = last;
        }
        oracles.length--;
        index[_oracle] = 0;
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
