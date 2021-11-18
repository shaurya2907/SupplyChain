import React, { Component } from "react";
import ItemManager from "./contracts/ItemManager.json";
import Item from "./contracts/Item.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {

  state = { itemName:"test_1",cost:0,loaded:false };
  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
       this.web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      this.accounts = await this.web3.eth.getAccounts();

      // Get the contract instance.
       this.networkId = await this.web3.eth.net.getId();
     
      this.itemManager = new this.web3.eth.Contract(
        ItemManager.abi,
        ItemManager.networks[this.networkId]&& ItemManager.networks[this.networkId].address,
      );

      this.item=  new this.web3.eth.Contract(
        Item.abi,
        Item.networks[this.networkId]&& Item.networks[this.networkId].address,
      );
      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
     
      this.listenToPaymentEvent();
     
      this.setState({ loaded:true });
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  listenToPaymentEvent =()=> {
    let self=this;
this.itemManager.events.SupplyChainStep().on("data", async function(evt){
console.log(evt);
let itemObj= await self.itemManager.methods.items(evt.returnValues.Itemindex).call();
alert("Item "+ itemObj._identifier +" was paid,deliver it now");
});



  }

  
  handleSubmit=async() =>{

    const {cost,itemName}=this.state;
    
let result =    await this.itemManager.methods.CreateItem(itemName, cost).send({from:this.accounts[0]});
  console.log(result);
alert("send "+cost+" Wei to" +result.events.SupplyChainStep.returnValues._itemAddress);

  };

    
  handleInputChange= (event) =>{

const target= event.target;
const value = target.type==='checkbox'? target.checked:target.value;
 const name= target.name;
this.setState({
  [name]:value
});


  }

 

  render() {
    if (!this.state.loaded) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Supply Chain Project</h1>
        
        <h2>Items</h2>
       <h2>Add Items</h2>
       Cost in Wei:<input type="text" name="cost" value={this.state.cost} onChange={this.handleInputChange} />

Item identifier<input type="text" name="itemName" value={this.state.itemName} onChange={this.handleInputChange}
/>

<button type="button" onClick={this.handleSubmit}>Create new Item</button>

      </div>
    );
  }
}

export default App;
