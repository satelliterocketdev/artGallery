const { descibe, assert } = require("chai");
const NftRegistry = artifacts.require("./NftRegistry");

require("chai").use(require("chai-as-promised")).should();

contract("NftRegistry", ([deployer, feeAccount, user1, user2]) => {
  let nftRegistry;
  const feePercent = 10;

  const EVM_REVERT = "VM Exception while processing transaction: revert";
  const toEther = (n) =>
    new web3.utils.BN(web3.utils.toWei(n.toString(), "ether"));

  beforeEach(async () => {
    nftRegistry = await NftRegistry.new(feeAccount, feePercent);
  });

  describe("deployment", async () => {
    // to make sure that the contract deployed successfully
    it("deploys successfully", async () => {
      const address = await nftRegistry.address;
      assert.notEqual(address, 0x0);
      assert.notEqual(address, "");
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
    });

    describe("Creating a Registry", async () => {
      let result;
      let totalRegistries;

      const Registry1 = {
        name: "TestRegistry1",
        Symbol: "TST",
        description: "TestDescription",
      };

      //creating the Registry
      beforeEach(async () => {
        result = await nftRegistry.createRegistry(
          Registry1.name,
          Registry1.symbol,
          Registry1.description
        );
        const totalRegistries = 1;
      });

      it("it creates a registry", async () => {
        // success creating a registry
        assert.equal(totalRegistries, 1);
      });
    });
  });
});
