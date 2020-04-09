pragma solidity >=0.5.0 <0.7.0;
import "./EIP2362Interface.sol";
import "./SafeMath.sol";

contract ADOMedianizer is EIP2362Interface{

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

  function changeOwner(address _newOwner) restricted() public{
    owner = _newOwner;
  }

  //This is the exposed EIP function that loops through the oracle addresses and medianizes the values
  function valueFor(bytes32 _id) public view returns(int,uint,uint){
    int[] values;
    int _val;
    uint _time;
    uint _status;
    for(uint i = 0; i< oracles.length;i++){
      _val,_time,_status = EIP2362Interface(oracles[i]).valueFor;
      if(_status == 200){
        values.push[_val];
      }
    }
    return (median(values),now,200);
  } 

  function addOracle(address _oracle) restricted() external{
    index[_oracle] = oracles.length;
    oracles.push(_oracle);
  }

  function removeOracle(address _oracle) restricted() external{
    uint _index = index[_oracle];
    if(_index != oracles.length){
      address last = oracles[oracles.length - 1];
      oracles[_index] = last;
    }
    oracles.length--;
    index[_oracle] = 0;
  }

  function median(int256[] memory a) internal returns(int){
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
  }

}
