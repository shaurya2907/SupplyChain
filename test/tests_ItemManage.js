const ItemManager = artifacts.require("./ItemManager.sol");

contract("ItemManager", accounts =>{
ItemManager("...should be able to add an item", async function(){

    const itemManagerInstace = await ItemManager.deployed();
    const itemName="test 1";
    const itemPrice= 500;

   const result= await itemManagerInstace.createItem(itemName,itemPrice, {from: accounts[0]});
console.log(result);


})


});