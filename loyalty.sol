pragma solidity >=0.8.0<0.9.0;

contract accountCreator is Ownable {

    struct LoyaltyAccount {
        uint points;
        uint cpf;
    }


    LoyaltyAccount[] public accounts;
    mapping(uint => address) public cpfToHolder;
    mapping(address => uint) public holderToCpf;
    mapping(address => uint) public holderToPoints;



    function _createAccount(uint _cpf) {
        uint id = accounts.push(LoyaltyAccount(0, _cpf));
        cpfToHolder[cpf] = msg.sender;
        emit NewAccount(id, _cpf, 0);
    }
    
    function getPoints(address _holder) external view returns (uint points) { 
        holderToPoints[_holder];
    }

    function 


}