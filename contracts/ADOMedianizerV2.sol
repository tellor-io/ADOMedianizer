pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/EnumerableSet.sol";


interface IERC2362
{
	/**
	 * @dev Exposed function pertaining to EIP standards
	 * @param _id bytes32 ID of the query
	 * @return int,uint,uint returns the value, timestamp, and status code of query
	 */
	function valueFor(bytes32 _id) external view returns(int256,uint256,uint256);
}

contract ADOMedianizerV2 is IERC2362, Ownable
{
	using EnumerableSet for EnumerableSet.AddressSet;

	EnumerableSet.AddressSet oracles;
	uint256 constant validity = 1 days; // make mutable by owner ?

	constructor() public {}

	function addOracle(address _oracle)
	external  onlyOwner()
	{
		oracles.add(_oracle);
	}

	function removeOracle(address _oracle)
	external  onlyOwner()
	{
		oracles.remove(_oracle);
	}

	function getOracles()
	external view returns(bytes32[] memory _oracles) // stored as bytes32, eventually need casting :/
	{
		return oracles._inner._values;
	}

	function valueFor(bytes32 _id)
	external view override returns (int256, uint256, uint256)
	{
		if (oracles.length() == 0) { return (0, 0, 404); }

		int256[] memory values = new int256[](oracles.length());
		uint256         length = 0;

		for (uint256 i = 0; i < oracles.length(); ++i)
		{
			try IERC2362(oracles.at(i)).valueFor(_id) returns (int256 val, uint256 time, uint256 status)
			{
				if (status >= 200 && status < 300 && time + validity > now) // valid HTTP status are all 2xx
				{
					values[length] = val;
					++length;
				}
			}
			catch (bytes memory /*lowLevelData*/) {}
		}

		if (length == 0) { return (0, 0, 400); }

		return (median(values, length), now, 200);
	}

	function median(int256[] memory array, uint256 length)
	internal pure returns(int256)
	{
		// insertion sort
		for (uint256 i = 1; i < length; ++i)
		{
			int256 temp = array[i];
			uint256 j;
			for (j = i; j > 0 && temp < array[j-1]; --j)
			{
				array[j] = array[j-1];
			}
			array[j] = temp;
		}
		// odd/even length management
		return length % 2 == 0 ? (array[length/2-1] + array[length/2]) / 2 : array[length/2];
	}

}
