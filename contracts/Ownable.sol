pragma solidity>=0.8.0;


contract Ownable{
    address payable owner;
    
    constructor(){
        owner= payable(msg.sender);
        
    }
    
    modifier onlyOwner(){
        
        require (isOwner(),"You are not allowed.");
        _;
        
    }
    
    function isOwner() public  view returns (bool){
        return msg.sender==owner;
        
    }
    
    
}