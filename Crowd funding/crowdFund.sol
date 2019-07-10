pragma solidity ^0.4.17;

contract projectFactory{
    address[] deployedProjects;
    
    function createProject(uint amount) public{
        deployedProjects.push(new Project(amount, msg.sender));
    }
    
    function getDeployedProjects() public view returns(address[]){
        return deployedProjects;
    }
}

contract Project{
    
    struct Request{
        string description;
        uint amount;
        address receiver;
        bool complete;
        uint approveCount;
        mapping(address=>bool) nodded; //track of approvers who said yes
    }
    Request[] public requests;
    address public manager;
    mapping(address=>bool) approvers;
    uint approverCount=0;
    uint minimumContribution;
    
    modifier restricted{
        require(msg.sender==manager);
        _;
    }
    
    function Project(uint amount, address creator) public payable{
        manager=creator;
        minimumContribution=amount;
    }
    
    function enter() public payable{
        require(msg.value > minimumContribution);
        approvers[msg.sender]=true;
        approverCount++;
    }
    
    function createRequest(string description, uint amount, address receiver) public restricted{
        Request memory newRequest=Request({
            description:description,
            amount:amount,
            receiver:receiver,
            complete:false,
            approveCount:0
        });
        requests.push(newRequest);
    }
    
    function approveRequest(uint index) public{
        Request storage currentRequest=requests[index];
        require(approvers[msg.sender]);
        
        require(!currentRequest.nodded[msg.sender]);
        currentRequest.nodded[msg.sender]=true;
        currentRequest.approveCount++;
    }
    
    function finalizeRequest(uint index) public restricted{
        Request storage currentRequest=requests[index];
        require(!currentRequest.complete);
        
        require(currentRequest.approveCount>(approverCount/2));
        currentRequest.receiver.transfer(currentRequest.amount);
        currentRequest.complete=true;
    }
} 
