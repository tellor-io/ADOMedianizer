# ADOMedianizer

A medianizer price oracle for the Alliance of Decentralized Oracles pertaining to EIP 2362. This is **unaudited** code for demo purposes only.

This repository provides and example of how smart contracts can easly use ADO compliant oracles to aggregate off-chain data and use in their contracts.

Contracts:

* ADOMedianizer - Pulls data from the specified ADO compliant oracles based on the standarized ADO data Id's. The ADOMedianizer includes(is) EIP2362Interface.

    * EIP2362Interface - is the standarized ADO oracle interface (EIP-2362).

* SampleOracle - is a test centralized oracle contract that is compliant with the EIP-2362 and used for testing ADOMedianizer. 


More information on EIP2362 can be found at:[https://github.com/tellor-io/EIP-2362](https://github.com/tellor-io/EIP-2362)

#### Disclaimer

This is **unaudited** code for demo purposes only.


#### Contributors<a name="contributors"> </a>

This repository is maintained by the Tellor team and the Alliance of Decentralized Oracles - [www.tellor.io](https://www.tellor.io)
