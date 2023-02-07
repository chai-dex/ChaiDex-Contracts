const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { ethers } = require("hardhat");

describe("P2P logic for INRC contract only with preset assumptions", function () {
    async function deployTokenFixture() {

        const P2PINRC = await ethers.getContractFactory("EscrowINRC");
          const Treasury = await ethers.getContractFactory("TreasuryPool");
          const Apy = await ethers.getContractFactory("Apy");
          const USDmock = await ethers.getContractFactory("TESTUSD");

          const instance = await upgrades.deployProxy(P2PINRC, []);
        //   const instance3= await upgrades.deployProxy(Treasury, []);
          const instance4 = await USDmock.deploy();
          const [owner, addr1, addr2] = await ethers.getSigners();
          console.log(owner.address);
          console.log(addr1.address);
          console.log(addr2.address);
        //   console.log(instance.address);
          console.log(instance.address);
          console.log(instance4.address);
          expect(await instance4.transfer(addr1.address,ethers.utils.parseEther("10000000")))
          expect(await instance4.transfer(addr2.address,ethers.utils.parseEther("10000000")))
          expect(await instance4.connect(addr1).approve(instance.address, ethers.utils.parseEther("10000000")))
          expect(await instance4.connect(addr2).approve(instance.address, ethers.utils.parseEther("10000000")))
          expect(await instance.setINRCAddress(instance4.address,instance4.address))
          expect(await instance4.approve(instance.address, 5000))
          return {  instance, instance4, owner, addr1, addr2};
      }
it('works', async () => {
    const { instance, instance4, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
});
    });
