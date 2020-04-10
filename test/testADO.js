/** 
* This tests the oracle functions as they are called through the
* 
*/
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'));
const BN = require('bn.js');  
const helper = require("./helpers/test_helpers");
const ADOMedianizer = artifacts.require("./ADOMedianizer.sol");
const SampleOracle = artifacts.require("./testContracts/sampleOracle.sol");
//const Mappings = artifacts.require("./OracleIDDescriptions");
var bytes = "0x2ecc80a3401165e1a04561d6ffe93662a31815d89cd63b00f248efd1cce47894";

contract('ADO Medianizer Tests', function(accounts) {
  let adoMedianizer;
  let sampleOracle;

    beforeEach('Setup contract for each test', async function () {
    	//Deploy multiple oracles
     //    for (var i =1;i<4;i++){
     //    let name = "sampleOracle" + i; 
     //    console.log("name", name)
    	// name = await SampleOracle.new()
    	// console.log(name.address)
    	// await name.setValue(bytes, i)
    	// console.log("i", i)
     //    }

        sampleOracle1 = await SampleOracle.new()
        sampleOracle2 = await SampleOracle.new()
        sampleOracle3 = await SampleOracle.new()

        await sampleOracle1.setValue(bytes, 1)
        await sampleOracle2.setValue(bytes, 2)
        await sampleOracle3.setValue(bytes, 3)

        //deploy medianizer contract
    	adoMedianizer = await ADOMedianizer.new()
    	console.log(adoMedianizer.address)

        //add oracles to medianizer
    	await adoMedianizer.addOracle(sampleOracle1.address)
    	console.log(1)
    	await adoMedianizer.addOracle(sampleOracle2.address)
    	console.log(2)
    	await adoMedianizer.addOracle(sampleOracle3.address)
    	console.log(3)
    })

    it("Test SampleOracle.valueFor", async function(){
        let vars = await sampleOracle1.valueFor(bytes)
        console.log("vars", vars)
    })

    it("Test ADOMEdianizer.valueFor", async function(){
        let vars1 = await adoMedianizer.valueFor(bytes)
        console.log("vars1", vars)
    })

    // it("Test ADOMEdianizer.removeOracle", async function(){
    //     let vars2 = await adoMedianizer.removeOracle(sampleOracle1)
    //     console.log("vars1", vars)

    // })


 });