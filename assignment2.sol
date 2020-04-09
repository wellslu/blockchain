pragma solidity ^0.6.0;

contract bank{
    mapping(string => address payable) user;
    mapping(address => uint) balances;
    address payable owner;
    mapping(address => bool) accountUser;
    uint BankBalance;
    event depositLog (address, uint);
    modifier isOwner(){
        require(owner == msg.sender, "你不是所有人，想騙?");
        _;
    }
    
    modifier isUser(address addr){
        require(accountUser[addr], "錢包沒註冊啦");
        _;
    }
    
    constructor() public payable{
        owner = msg.sender;
    }
    function enroll(string calldata studentId) external{
        accountUser[msg.sender] = true;
        user[studentId] = msg.sender;
        balances[msg.sender] = 0;
    }
    function deposit() external payable isUser(msg.sender){
        require(msg.value > 0,"沒錢存還來搞?");
        balances[msg.sender] = balances[msg.sender] + msg.value;
        emit depositLog(msg.sender, msg.value);
        BankBalance = BankBalance + msg.value;
        
    }
    function withdraw (uint withdrawAmount) external isUser(msg.sender) payable returns (uint256 balance){
        require(balances[msg.sender] >= withdrawAmount, "你沒這麼多錢，死窮鬼");
        msg.sender.transfer(withdrawAmount);
        balances[msg.sender] = balances[msg.sender] - withdrawAmount;
        BankBalance = BankBalance - withdrawAmount;
        return balances[msg.sender];
    }
    function transfer(uint transferAmount, address transferTo) external isUser(msg.sender) isUser(transferTo) payable returns (uint256 balance){
        require(balances[msg.sender] >= transferAmount, "你沒這麼多錢，死窮鬼");
        balances[transferTo] = balances[transferTo] + transferAmount;
        balances[msg.sender] = balances[msg.sender] - transferAmount;
        return balances[msg.sender];
    }
    function getBankBalance() external isOwner() view returns(uint){
        require(owner == msg.sender, "你不是所有人，想騙?");
        return BankBalance;
    }
    function getBalance()external isUser(msg.sender) view returns(uint){
        return balances[msg.sender];
    }

    fallback() external isOwner(){
        selfdestruct(owner);
    }
}
