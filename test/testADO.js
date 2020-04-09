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

    it("Test ContractSetup", async function(){
    })

    it("Test valueFor", async function(){
    })
    
 });