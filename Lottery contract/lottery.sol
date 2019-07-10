pragma solidity ^0.4.17;

contract Lottery{
    address public manager;
    address[] public approvers;
    
    function Lottery() public payable{
        manager=msg.sender;
    }
    
    function enter() public payable{
        require(msg.value > .001 ether);
        approvers.push(msg.sender);
    }
    
    // function members() view public returns(address[]){
    //     return participants;
    
    function rand() public view returns(uint256){
        return uint(keccak256(block.difficulty, now, approvers));
    }
    
    function pick() public restiricted{
        uint index=rand()%participants.length;
        participants[index].transfer(this.balance);
        participants=new address[](0);
    }
    
    function approvers() public view returns(address[]){
        return approvers;
    }
    
    modifier restiricted(){
        require(msg.sender==manager);
        _;
    }
} 
