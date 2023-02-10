const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { ethers } = require("hardhat");

describe("Deployment and functioning of LP", function() {

  async function deployTokenFixture() {

    const Liquidity = await ethers.getContractFactory("LiquidityPool");
      const Treasury = await ethers.getContractFactory("TreasuryPool");
      const Apy = await ethers.getContractFactory("Apy");
      const USDmock = await ethers.getContractFactory("TESTUSD");

      const instance = await upgrades.deployProxy(Liquidity, []);
      const instance3= await upgrades.deployProxy(Treasury, []);
      const instance4 = await USDmock.deploy();
      const [owner, addr1, addr2] = await ethers.getSigners();
      console.log(owner.address);
      console.log(addr1.address);
      console.log(addr2.address);
      console.log(instance.address);
      console.log(instance3.address);
      console.log(instance4.address);
      expect(await instance4.transfer(addr1.address,ethers.utils.parseEther("10000000")))
      expect(await instance4.transfer(addr2.address,ethers.utils.parseEther("10000000")))
      expect(await instance4.connect(addr1).approve(instance.address, ethers.utils.parseEther("10000000")))
      expect(await instance4.connect(addr2).approve(instance.address, ethers.utils.parseEther("10000000")))
      expect(await instance.setUSDAddress(0,"USDC",instance4.address,))
      expect(await instance4.approve(instance.address, 5000))
      return { instance, instance3, instance4, owner, addr1, addr2};


  }

    it('works', async () => {
       const { instance, instance3, instance4, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
        expect(await instance.setUSDAddress(0,"USDC",instance4.address,))
    });

    it('staking and unstaking with epoch over condition ', async () => {
    //     const [owner, addr1, addr2] = await ethers.getSigners();

    //   const Liquidity = await ethers.getContractFactory("LiquidityPool");
    // //   const DEX = await ethers.getContractFactory("htlc");
    // //   const Treasury = await ethers.getContractFactory("TreasuryPool");
    // //   const Apy = await ethers.getContractFactory("Apy");
    //   const USDmock = await ethers.getContractFactory("TESTUSD");

    //   const instance = await upgrades.deployProxy(Liquidity, []);
    // //   const instance2 = await upgrades.deployProxy(DEX, []);
    // //   const instance3= await upgrades.deployProxy(Treasury, []);
    //   const instance4 = await USDmock.deploy();
    const { instance, instance3, instance4, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
      console.log(instance.address);
      console.log(instance4.address);
      // expect(await instance.setUSDAddress(0,"USDC",instance4.address,))
      // expect(await instance4.approve(instance.address, 5000))
       expect(await instance.stake(0,1000))
       expect(await instance.connect(addr1).stake(0,12120))


      const LPbalance=  await instance.LPbalanceUSD(0);
       expect( await instance4.balanceOf(instance.address)).to.equal(LPbalance);
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
    //     const [owner, addr1, addr2] = await ethers.getSigners();

    //   const Liquidity = await ethers.getContractFactory("LiquidityPool");
    // //   const DEX = await ethers.getContractFactory("htlc");
    // //   const Treasury = await ethers.getContractFactory("TreasuryPool");
    // //   const Apy = await ethers.getContractFactory("Apy");
    //   const USDmock = await ethers.getContractFactory("TESTUSD");

    //   const instance = await upgrades.deployProxy(Liquidity, []);
    // //   const instance2 = await upgrades.deployProxy(DEX, []);
    // //   const instance3= await upgrades.deployProxy(Treasury, []);
    //   const instance4 = await USDmock.deploy();

    //   console.log(instance.address);
    //   console.log(instance4.address);
    //   expect(await instance.setUSDAddress(0,"USDC",instance4.address,))
    //   expect(await instance4.approve(instance.address, 5000))
    const { instance, instance3, instance4, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
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
      const { instance, instance3, instance4, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
    //   const [owner, addr1, addr2] = await ethers.getSigners();

    //   const Liquidity = await ethers.getContractFactory("LiquidityPool");
    // //   const DEX = await ethers.getContractFactory("htlc");
    // //   const Treasury = await ethers.getContractFactory("TreasuryPool");
    // //   const Apy = await ethers.getContractFactory("Apy");
    //   const USDmock = await ethers.getContractFactory("TESTUSD");

    //   const instance = await upgrades.deployProxy(Liquidity, []);
    // //   const instance2 = await upgrades.deployProxy(DEX, []);
    // //   const instance3= await upgrades.deployProxy(Treasury, []);
    //   const instance4 = await USDmock.deploy();

    //   console.log(instance.address);
    //   console.log(instance4.address);
    //   expect(await instance.setUSDAddress(0,"USDC",instance4.address,))
    //   expect(await instance4.approve(instance.address, 5000))
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

      it('onlyOwner should revert for calls  from other account', async () => {
        const { instance, instance3, instance4, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
        await expect( instance.connect(addr1).setUSDAddress(0,"USDC",instance4.address,)).to.be.revertedWith('Ownable: caller is not the owner').then(console.log('setUSDAddress reverted as expected'));
        await expect( instance.connect(addr1).pause()).to.be.revertedWith('Ownable: caller is not the owner').then(console.log('pause reverted as expected'));
        await expect( instance.connect(addr1).unpause()).to.be.revertedWith('Ownable: caller is not the owner').then(console.log('unpause reverted as expected'));
        await expect( instance.connect(addr1).setEpoch(true)).to.be.revertedWith('Ownable: caller is not the owner').then(console.log('setEpoch reverted as expected'));
        await expect( instance.connect(addr1).setUnstake(true)).to.be.revertedWith('Ownable: caller is not the owner').then(console.log('setUnstake reverted as expected'));

      });

      it('all functions should revert when paused', async () => {
        const { instance, instance3, instance4, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
        expect(await instance.pause())
        await expect( instance.setUSDAddress(0,"USDC",instance4.address,)).to.be.revertedWith('Pausable: paused').then(console.log('setUSDAddress reverted as expected'));
        await expect( instance.connect(addr1).stake(0,1000)).to.be.revertedWith('Pausable: paused').then(console.log('stake reverted as expected'));
        await expect( instance.connect(addr1).unstake(0,1000)).to.be.revertedWith('Pausable: paused').then(console.log('unstake reverted as expected'));
        await expect( instance.setEpoch(true)).to.be.revertedWith('Pausable: paused').then(console.log('setEpoch reverted as expected'));
        await expect( instance.setUnstake(true)).to.be.revertedWith('Pausable: paused').then(console.log('setUnstake reverted as expected'));
      });

      it('get all balances and get stakers', async () => {
        const { instance, instance3, instance4, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
        expect(await instance.stake(0,1000))
        expect(await instance.stake(0,1000))
        expect(await instance.connect(addr1).stake(0,1000))
        const lpbalance =await  instance.getLPbalance(2);
        console.log(lpbalance);
        const stakers=await instance.GetStakers(0,2)
        console.log("get stakers complete",stakers);
      });

  });