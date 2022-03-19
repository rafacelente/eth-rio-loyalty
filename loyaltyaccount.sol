pragma solidity >=0.8.0<0.9.0;

contract accountCreator {

    event NewAccount (uint cpf, uint id, uint points);
    event NewRestaurant (uint cnpj, uint id);

    
    struct LoyaltyAccount {
        string name;
        uint points;
        uint cpf;
    }

    struct Restaurant {
        string name;
        uint cnpj;
    }

    LoyaltyAccount[] public accounts;
    Restaurant[] public restaurants;
    mapping(uint => address) public cpfToHolder;
    mapping(address => uint) public holderToCpf;
    mapping(address => uint) public holderToPoints;
    mapping(address => uint) public restaurantToCnpj;
    mapping(uint => address) public cnpjToRestaurant;

    function createAccount(string memory _name, uint _cpf) external {
        uint id = accounts.push(LoyaltyAccount(_name, 0, _cpf)) - 1;
        cpfToHolder[_cpf] = msg.sender;
        emit NewAccount(id, _cpf, 0);
    }

    function createRestaurant(string memory _name, uint _cnpj) external {
        uint id = restaurants.push(Restaurant(_name, _cnpj)) - 1;
        cnpjToRestaurant[_cnpj] = msg.sender;
        emit NewRestaurant(id, _cnpj);
    }

    function getPoints(address _holder) external view returns (uint points) {
        return holderToPoints[_holder];
    }

    function addPoints(uint _cpf, uint points_added) internal {
        accounts[_cpf].points += points_added; 
    }

}