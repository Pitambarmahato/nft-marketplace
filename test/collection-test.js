const { expect } = require('chai');
const { ethers } = require('hardhat');

describe("Test Collection", () =>{
    it("should set maxsupplye", async () =>{
        const Collection = await ethers.getContractFactory('Collection');
        const collection  = await Collection.deploy();
        await collection.deployed();

        console.log(collection.address);

        try{
            await collection.setMaxSupply(23);
            console.log("Max Supply Added")
        }catch(error){
            console.log(error)
        }
    })
})