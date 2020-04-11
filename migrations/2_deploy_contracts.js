var ADOMedianizer = artifacts.require("./ADOMedianizer.sol");
var sampleOracle = artifacts.require("./testContracts/sampleOracle.sol");


function sleep_s(secs) {
  secs = (+new Date) + secs * 1000;
  while ((+new Date) < secs);
}

module.exports = async function (deployer) {

	// ADOMedianizer
    await deployer.deploy(ADOMedianizer);
    sleep_s(30);

    // sampleOracle
    await deployer.deploy(sampleOracle);


};