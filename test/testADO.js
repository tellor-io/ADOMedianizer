/** 
* This tests the oracle functions as they are called through the
* TestContract(which is Optimistic and Optimistic is UsingTellor).
*/
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'));
const BN = require('bn.js');  
const helper = require("./helpers/test_helpers");
const ADO = artifacts.require("./ADOMedianizer.sol");
const Mappings = artifacts.require("./OracleIDDescriptions");
var bytes = "0x0d7effefdb084dfeb1621348c8c70cc4e871eba4000000000000000000000000";

contract('ADO Medianizer Tests', function(accounts) {
  let ado;

    beforeEach('Setup contract for each test', async function () {

    })

    it("Test getContractSetup", async function(){
        for(var i = 0;i <=4 ;i++){
          await web3.eth.sendTransaction({to: oracle.address,from:accounts[i],gas:4000000,data:oracle2.methods.submitMiningSolution("nonce",1, 1200).encodeABI()})
         }
        let vars = await usingTellor.getCurrentValue.call(1)
        assert(vars[0] == true, "ifRetreive is not true")
        assert(vars[1] == 1200, "Get last value should work")
    })

    it("Test valueFor", async function(){
        for(var i = 0;i <=4 ;i++){
          await web3.eth.sendTransaction({to: oracle.address,from:accounts[i],gas:4000000,data:oracle2.methods.submitMiningSolution("nonce",1, 1200).encodeABI()})
         }
        let _id = web3.utils.keccak256(api, 1000)
        let vars = await usingTellor.resultFor(bytes)
        assert(vars[0]> 0 , "timestamp works")
        assert(vars[1] == 1200, "Get value should work")
        assert(vars[2] == 200, "Get status should work")
    })
    
 });