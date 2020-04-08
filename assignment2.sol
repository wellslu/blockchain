pragma solidity ^0.6.0;

contract bank{
    mapping(string => address payable) user;
    mapping(address => uint) balances;
    address payable owner;
    mapping(address => bool) accountUser;
    uint BankBalance;
    constructor() public payable{
        owner = msg.sender;
    }
    function enroll(string calldata studentId) external{
        accountUser[msg.sender] = true;
        user[studentId] = msg.sender;
        balances[msg.sender] = 0;
    }
    function deposit() external payable{
        require(msg.value > 0,"沒錢存還來搞?");
        balances[msg.sender] = balances[msg.sender] + msg.value;
        
    }
    function withdraw (uint withdrawAmount) external payable returns (uint256 balance){
        require(accountUser[msg.sender], "這錢包還沒註冊");
        require(balances[msg.sender] >= withdrawAmount, "你沒這麼多錢，死窮鬼");
        msg.sender.transfer(withdrawAmount);
        balances[msg.sender] = balances[msg.sender] - withdrawAmount;
        return balances[msg.sender];
    }
    function transfer(uint transferAmount, address transferTo) external payable returns (uint256 balance){
        require(accountUser[transferTo], "沒有你想轉往的目的地");
        require(balances[msg.sender] >= transferAmount, "你沒這麼多錢，死窮鬼");
        balances[transferTo] = balances[transferTo] + transferAmount;
        balances[msg.sender] = balances[msg.sender] - transferAmount;
        return balances[msg.sender];
    }
    function getBankBalance() external view returns(uint){
        require(owner == msg.sender, "你不是所有人，想騙?");
        return BankBalance;
    }
    function getBalance()external view returns(uint){
        require(accountUser[msg.sender], "這錢包還沒註冊");
        return balances[msg.sender];
    }

    fallback() external{
        require(owner == msg.sender, "你不是所有人，想騙?");
        selfdestruct(owner);
    }
}
