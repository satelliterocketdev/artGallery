const CifiPowa = artifacts.require("CifiPowa");
const ArtGallery = artifacts.require("ArtGallery");
// const CifiPowa1155 = artifacts.require("CifiPowa1155");
// const ArtGallery1155 = artifacts.require("ArtGallery1155");
module.exports = async function (deployer) {
  const accounts = await web3.eth.getAccounts();
  const feeAccount = accounts[0];
  console.log(feeAccount);
  await deployer.deploy(CifiPowa);
  // await deployer.deploy(ArtGallery);
};
