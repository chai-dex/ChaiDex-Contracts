// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const { upgrades, ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  /**
   * HTLC deployment script
   */
  const HTLC = await hre.ethers.getContractFactory("htlc");
  const deploymentHTLC = await hre.upgrades.deployProxy(HTLC, [], {
    initializer: "initialize",
  });
  await deploymentHTLC.deployed();

  console.log("HTLC ADDRESS:", deploymentHTLC.address);

  /**
   * LIQUIDITY POOL deployment script , to be deployed on the same network as the HTLC
   */

  const LIQUIDITY_POOL = await hre.ethers.getContractFactory("LiquidityPool");
  const deploymentLiquidityPool = await hre.upgrades.deployProxy(
    LIQUIDITY_POOL,
    [],
    {
      initializer: "initialize",
    }
  );

  await deploymentLiquidityPool.deployed();
  console.log("LIQUIDITY POOL ADDRESS:", deploymentLiquidityPool.address);

  /**
   * TREASURY POOL deployment script , to be deployed on the same network as the HTLC
   */

  const TREASURY_POOL = await hre.ethers.getContractFactory("TreasuryPool");
  const deploymentTreasuryPool = await hre.upgrades.deployProxy(
    TREASURY_POOL,
    [],
    {
      initializer: "initialize",
    }
  );
  await deploymentTreasuryPool.deployed();
  console.log("TREASURY POOL:", deploymentTreasuryPool.address);

  /**
   * INRC deployment script, to be only launched on bitgert else comment out
   */
  // const INRC = await hre.ethers.getContractFactory("INRChai");
  // const deploymentINRC = await INRC.deploy();
  // await deploymentINRC.deployed();

  // console.log("INRC ADDRESS:", deploymentINRC.address);

  /**
   * CHAIT deployment script to be only launched on bitgert else comment out
   */

  //   const CHAIT = await hre.ethers.getContractFactory("Chai");
  //   const deploymentCHAIT = await hre.upgrades.deployProxy(CHAIT, [], {
  //     initializer: "initialize",
  //   });

  //   await deploymentCHAIT.deployed();
  //   console.log("CHAIT ADDRESS:", deploymentCHAIT.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
