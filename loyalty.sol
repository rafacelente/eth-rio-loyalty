pragma solidity >=0.8.0<0.9.0;

contract accountCreator is Ownable {

    struct LoyaltyAccount {
        uint points;
        uint cpf;
        address holder;
    }


    LoyaltyAccount[] public accounts;
    mapping(uint => address) public cpfToHolder;
    mapping(address => uint) public holderToCpf;
    mapping(address => uint) public holderToPoints;

    
    
    function getPoints(address _holder) external view returns (uint points) { 
        holderToPoints[_holder];
    }

    function 


}