require('dotenv').config();
const privateKeys = process.env.PRIVATE_KEYS || ""
const HDWalletProvider = require('@truffle/hdwallet-provider');


module.exports = {
  networks: {

    bsc_testnet: {
      provider: () => new HDWalletProvider(
        privateKeys.split(','),
        `wss://data-seed-prebsc-1-s1.binance.org:8545`
      ),
      network_id: 97,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true,
      networkCheckTimeout: 1000000,
    },
    bsc_mainnet: {
      provider: () => new HDWalletProvider(
        privateKeys.split(','),
        `wss://bsc-dataseed1.binance.org`
      ),
      network_id: 56,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true,
      networkCheckTimeout: 1000000,
    },

    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",
    },
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  contracts_directory: './src/contracts/',
  contracts_build_directory: './src/abis/',
  // Configure your compilers
  compilers: {
    solc: {
      version: "0.7.4", // Fetch exact version from solc-bin (default: truffle's version)
      //docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {
        // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200,
        },
        //  evmVersion: "byzantium"
      },
    },
  },

  // Truffle DB is currently disabled by default; to enable it, change enabled: false to enabled: true
  //
  // Note: if you migrated your contracts prior to enabling this field in your Truffle project and want
  // those previously migrated contracts available in the .db directory, you will need to run the following:
  // $ truffle migrate --reset --compile-all

  db: {
    enabled: false
  }
};
