function sleep_s(secs) {
  secs = (+new Date) + secs * 1000;
  while ((+new Date) < secs);
}
// truffle-flattener ./contracts/Tellor.sol > ./flat_files/Tellor_flat.sol
// truffle exec scripts/01_DeployTellor.js --network rinkeby

var ADOMedianizer = artifacts.require("./ADOMedianizer.sol");
var SampleOracle = artifacts.require("./SampleOracle.sol");

//ADOMedianizer address: 
//0x62fa18Db18643C4C5234245c805c5E365f4F9E74
let usingTellor = "0x27C4E97b2319D72E0Be359d2245B95e1C12909CA";

module.exports =async function(callback) {
	let adoMedianizer;
	let sampleOracle1;
  let sampleOracle2;
    

  // deploy ado
  adoMedianizer = await ADOMedianizer.new();
  console.log('ADOMedianizer address:', ado.address);
  sleep_s(10);

  sampleOracle1 = await SampleOracle.new();
  sampleOracle2 = await SampleOracle.new();
  console.log('SampleOracle1 address:', sampleOracle1.address);
  console.log('SampleOracle2 address:', sampleOracle2.address);
  sleep_s(10);

  await adoMedianizer.addOracle(sampleOracle1.address)
  await adoMedianizer.addOracle(sampleOracle2.address)
  await adoMedianizer.addOracle(usingTellor)

  await sampleOracle1.setValue(bytes,1000) 
  await sampleOracle2.setValue(bytes,2000) 

  let vars = await adoMedianizer.valueFor(bytes)
  console.log('vars[0]', web3.utils.hexToNumberString(vars[0]))
  console.log('vars[1]', web3.utils.hexToNumberString(vars[1]))
  console.log('vars[2]', web3.utils.hexToNumberString(vars[2]))


}