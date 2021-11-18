pragma solidity>=0.8.0;
import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable{
    
    enum SupplyChainState{Created,Paid,Delivered}
    
    
    struct S_items{
        Item _item;
        
        string _Identifier;
        uint _itemprice;
        ItemManager.SupplyChainState state;
        
        
    }
    mapping(uint =>S_items) public items;
    uint Itemindex;
    
    event SupplyChainStep(uint Itemindex, uint _step, address _itemAddress);
    
    
    
    function CreateItem(string memory _Identifier, uint _itemprice) public onlyOwner {
        Item item = new Item(this, _itemprice,Itemindex);
        items[Itemindex]._item= item;
        items[Itemindex]._Identifier=_Identifier;
        items[Itemindex]._itemprice =_itemprice;
        items[Itemindex].state=SupplyChainState.Created;
        emit SupplyChainStep(Itemindex,uint(items[Itemindex].state),address(item));
        Itemindex++;
    }
    
    
    function triggerPayment(uint _Itemindex) public payable{
        
        
        
        require(items[_Itemindex]._itemprice==msg.value,"Only full payments accepted");
        require(items[_Itemindex].state==SupplyChainState.Created,"Item is further in the chain");
        
        items[_Itemindex].state=SupplyChainState.Paid;
        
        emit SupplyChainStep(_Itemindex,uint(items[_Itemindex].state),address(items[_Itemindex]._item));
        
    }
    
    function triggerDelivery(uint _Itemindex) public onlyOwner{
         
        require(items[_Itemindex].state==SupplyChainState.Paid,"Item is further in the chain");
        items[_Itemindex].state=SupplyChainState.Delivered;
        //eventemit
        
        
        emit SupplyChainStep(_Itemindex,uint(items[_Itemindex].state),address(items[_Itemindex]._item));
        
        
        
    }
    
    
    
    
    
}