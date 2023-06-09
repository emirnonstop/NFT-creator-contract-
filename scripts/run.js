const main = async () => { 
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const nftFactoryContract = await hre.ethers.getContractFactory('MyEpicNFT');
    const nftContract = await nftFactoryContract.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    let txn = await nftContract.makeEpicNFT();
    await txn.wait()
    
    // Mint another NFT for fun.
    txn = await nftContract.connect(randomPerson).makeEpicNFT();
    // Wait for it to be mined.
    await txn.wait()
}; 

const runMain = async () => { 
    try{ 
        await main();
        process.exit(0);
    } catch (error){
        console.log(error);
        process.exit(1);
    }
};

runMain();