pragma solidity >=0.8.0<0.9.0;

contract accountCreator is Ownable {

    event NewAccount (uint cpf, uint id, uint points);
    event NewRestaurant (uint cnpj, uint id);

    //posteriormente vai precisar ser criterizado como pontos por restaurante
    struct LoyaltyAccount {
        uint points;
        uint cpf;
    }

    struct Restaurant {
        uint cnpj;
    }

    LoyaltyAccount[] public accounts;
    Restaurant[] public restaurants;
    mapping(uint => address) public cpfToHolder;
    mapping(address => uint) public holderToCpf;
    mapping(address => uint) public holderToPoints;
    mapping(address => uint) public restaurantToCnpj;
    mapping(uint => address) public cnpjToRestaurant;

    function createAccount(uint _cpf) external {
        uint id = accounts.push(LoyaltyAccount(0, _cpf)) - 1;
        cpfToHolder[cpf] = msg.sender;
        emit NewAccount(id, _cpf, 0);
    }

    function createRestaurant(uint _cpnj) external {
        uint id = restaurants.push(Restaurant(_cnpj)) - 1;
        cnpjToRestaurant[_cnpj] = msg.sender;
        emit NewRestaurant(id, _cpnj);
    }

    function getPoints(address _holder) external view returns (uint points) { 
        return holderToPoints[_holder];
    }

    function addPoints(address _cpf, uint points_added) internal {
        accounts[_cpf].points += points_added; 
    }

}