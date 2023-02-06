const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("Deployment and functioning of LP", function() {
    it('works', async () => {
        const [owner, addr1, addr2] = await ethers.getSigners();

      const Liquidity = await ethers.getContractFactory("LiquidityPool");
      const Treasury = await ethers.getContractFactory("TreasuryPool");
      const Apy = await ethers.getContractFactory("Apy");
      const USDmock = await ethers.getContractFactory("TESTUSD");

      const instance = await upgrades.deployProxy(Liquidity, []);
      const instance3= await upgrades.deployProxy(Treasury, []);
      const instance4 = await USDmock.deploy();

      console.log(instance.address);
      console.log(instance3.address);
      console.log(instance4.address);


    });

    it('staking and unstaking with epoch over condition ', async () => {
        const [owner, addr1, addr2] = await ethers.getSigners();

      const Liquidity = await ethers.getContractFactory("LiquidityPool");
    //   const DEX = await ethers.getContractFactory("htlc");
    //   const Treasury = await ethers.getContractFactory("TreasuryPool");
    //   const Apy = await ethers.getContractFactory("Apy");
      const USDmock = await ethers.getContractFactory("TESTUSD");

      const instance = await upgrades.deployProxy(Liquidity, []);
    //   const instance2 = await upgrades.deployProxy(DEX, []);
    //   const instance3= await upgrades.deployProxy(Treasury, []);
      const instance4 = await USDmock.deploy();

      console.log(instance.address);
      console.log(instance4.address);
      expect(await instance.setUSDAddress(0,"USDC",instance4.address,))
      expect(await instance4.approve(instance.address, 5000))
      expect(await instance.stake(0,1000))

      await expect( instance.unstake(0,1000)).to.be.revertedWith('Treasury Pool: Amount is Zero or Greater than Stake').then(console.log("reverted as expected with amount incorrect error"));
      expect(await instance.setEpoch(true))
      expect(await instance.setUnstake(true))
       expect( await instance.unstake(0,700))
       console.log("unstaked 80% proceeding to unstake all");
       expect( await instance.unstakeAll(0))
       console.log(" unstake all complete");;
      var ownerBalance = await instance4.balanceOf(owner.address);
      var contBalance = await instance4.balanceOf(instance.address);
      console.log(ownerBalance);
      console.log(contBalance);
    //   console.log(instance4.allowance(instance.address));
    });

    it('staking and unstaking with epoch not over condition  Should revert with epoch not over', async () => {
        const [owner, addr1, addr2] = await ethers.getSigners();

      const Liquidity = await ethers.getContractFactory("LiquidityPool");
    //   const DEX = await ethers.getContractFactory("htlc");
    //   const Treasury = await ethers.getContractFactory("TreasuryPool");
    //   const Apy = await ethers.getContractFactory("Apy");
      const USDmock = await ethers.getContractFactory("TESTUSD");

      const instance = await upgrades.deployProxy(Liquidity, []);
    //   const instance2 = await upgrades.deployProxy(DEX, []);
    //   const instance3= await upgrades.deployProxy(Treasury, []);
      const instance4 = await USDmock.deploy();

      console.log(instance.address);
      console.log(instance4.address);
      expect(await instance.setUSDAddress(0,"USDC",instance4.address,))
      expect(await instance4.approve(instance.address, 5000))
      expect(await instance.stake(0,1000))
      expect(await instance.setUnstake(true))
      await  expect(  instance.unstake(0,1000)).to.be.revertedWith('Treasury Pool: Amount is Zero or Greater than Stake').then(console.log("reverted as expected with amount incorrect error"));
      await  expect(  instance.unstake(0,700))
       console.log("unstaked 80% proceeding to unstake all");
       await  expect(  instance.unstakeAll(0)).to.be.revertedWith('epoch not over')
       console.log(" unstake all reverted as expected");
      var ownerBalance = await instance4.balanceOf(owner.address);
      var contBalance = await instance4.balanceOf(instance.address);
      console.log(ownerBalance);
      console.log(contBalance);
    //   console.log(instance4.allowance(instance.address));
    });

    it('pause and unpause for unstake', async () => {
      const [owner, addr1, addr2] = await ethers.getSigners();

      const Liquidity = await ethers.getContractFactory("LiquidityPool");
    //   const DEX = await ethers.getContractFactory("htlc");
    //   const Treasury = await ethers.getContractFactory("TreasuryPool");
    //   const Apy = await ethers.getContractFactory("Apy");
      const USDmock = await ethers.getContractFactory("TESTUSD");

      const instance = await upgrades.deployProxy(Liquidity, []);
    //   const instance2 = await upgrades.deployProxy(DEX, []);
    //   const instance3= await upgrades.deployProxy(Treasury, []);
      const instance4 = await USDmock.deploy();

      console.log(instance.address);
      console.log(instance4.address);
      expect(await instance.setUSDAddress(0,"USDC",instance4.address,))
      expect(await instance4.approve(instance.address, 5000))
      expect(await instance.stake(0,1000))
      expect(await instance.setUnstake(true))
      expect(await instance.setEpoch(true))
      expect(await instance.pause())
      await  expect(  instance.unstake(0,200)).to.be.revertedWith('Pausable: paused').then(console.log("reverted as expected with paused error"));
      await  expect(  instance.unstakeAll(0)).to.be.revertedWith('Pausable: paused').then(console.log("reverted as expected with paused error"));
      console.log("Unpausing");
      expect(await instance.unpause())
      console.log("Unpaused");
      await  expect(  instance.unstake(0,700))
      await expect( instance.unstakeAll(0))
      console.log(" unstake all complete");
      await expect( instance.unstakeAll(0)).to.be.revertedWith('Amount cannot be 0').then(console.log("reverted as expected with amount zero error"));
      var ownerBalance = await instance4.balanceOf(owner.address);
      var contBalance = await instance4.balanceOf(instance.address);
      console.log(ownerBalance);
      console.log(contBalance);

      });
      it


  });