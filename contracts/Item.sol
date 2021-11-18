pragma solidity >=0.8.0;

import "./ItemManager.sol";

contract Item{
    
    uint public Itempriceinwei;
    uint public index;
    uint public pricePaid;
    
    
    ItemManager parentContract;
    
    constructor(ItemManager _parentContract ,uint _priceInWei, uint _index )  {
        
        _priceInWei=Itempriceinwei;
        _index=index;
        _parentContract=parentContract;
        
       
        
        
        
    }
    
    
    receive() external payable{
        require(pricePaid==0,"Item is paid already");
        require(Itempriceinwei==msg.value,"Omly full payments allowed");
        pricePaid+=msg.value;
       (bool success,)= address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)",index));
       require(success,"Transaction failed,Cancelling...");
        
    }
    
     fallback() external{}
    
    
    
    
}