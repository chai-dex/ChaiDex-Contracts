const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { ethers } = require("hardhat");

describe("TreasuryPool deployment and functioning", function () {
    async function deployTokenFixture() {

        const Liquidity = await ethers.getContractFactory("LiquidityPool");
          const Treasury = await ethers.getContractFactory("TreasuryPool");
          const Apy = await ethers.getContractFactory("Apy");
          const USDmock = await ethers.getContractFactory("TESTUSD");

        //   const instance = await upgrades.deployProxy(Liquidity, []);
          const instance3= await upgrades.deployProxy(Treasury, []);
          const instance4 = await USDmock.deploy();
          const [owner, addr1, addr2] = await ethers.getSigners();
          console.log(owner.address);
          console.log(addr1.address);
          console.log(addr2.address);
        //   console.log(instance.address);
          console.log(instance3.address);
          console.log(instance4.address);
          expect(await instance4.transfer(addr1.address,ethers.utils.parseEther("10000000")))
          expect(await instance4.transfer(addr2.address,ethers.utils.parseEther("10000000")))
          expect(await instance4.connect(addr1).approve(instance3.address, ethers.utils.parseEther("10000000")))
          expect(await instance4.connect(addr2).approve(instance3.address, ethers.utils.parseEther("10000000")))
          expect(await instance3.setUSDAddress(0,"USDC",instance4.address))
          expect(await instance4.approve(instance3.address, 5000))
          return {  instance3, instance4, owner, addr1, addr2};


      }
      it('Treasury Pool works', async () => {
         const { instance3, instance4, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
          expect(await instance3.setUSDAddress(0,"USDC",instance4.address))
      });

      it ('Buy function should work with maxminted false', async () => {
        const { instance3, instance4, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
        expect(await instance3.Buy(0,121211,100))
        contBalance= await instance4.balanceOf(instance3.address)
        console.log(contBalance.toString())
         expect(await instance3.BuyNat(1212,{value: ethers.utils.parseEther("1")}))
         contNatbalance= await ethers.provider.getBalance(instance3.address)
            console.log(contNatbalance.toString())
        });
        it ('Buy function should not work with maxminted true', async () => {
        const { instance3, instance4, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
        expect(await instance3.setMinter(true))
        await  expect( instance3.connect(addr1).Buy(0,121211,100)).to.be.revertedWith("Maximum minting reached").then(console.log("reverted as maxminted"));
        console.log("testing BuyNat")
        await expect( instance3.connect(addr2).BuyNat(1212,{value: ethers.utils.parseEther("1")})).to.be.revertedWith("Maximum minting reached").then(console.log("reverted as maximinted"));
        contBalance= await instance4.balanceOf(instance3.address)
        console.log(contBalance.toString())
        });


        it ('Redeem function as owner should work', async () => {
        const { instance3, instance4, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
        expect(await instance3.Buy(0,121211,100))
        contBalance= await instance4.balanceOf(instance3.address)
        console.log(contBalance.toString())
        expect(await instance3.Redeem(addr2.address,0,100))
        contBalance= await instance4.balanceOf(instance3.address)
        userBalance= await instance4.balanceOf(addr2.address)
        console.log(userBalance.toString())
        console.log(contBalance.toString())
        });

        it ('RedeemNat function as  owner should  work', async () => {
        const { instance3, instance4, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
        expect(await instance3.BuyNat(1212,{value: ethers.utils.parseEther("1")}))
        contNatbalance= await ethers.provider.getBalance(instance3.address)
        console.log(contNatbalance.toString())
        expect(await instance3.RedeemNat(addr2.address,1212))
        contNatbalance= await ethers.provider.getBalance(instance3.address)
        userNatBalance= await ethers.provider.getBalance(addr2.address)
        console.log(userNatBalance.toString())
        console.log(contNatbalance.toString())

});




    });