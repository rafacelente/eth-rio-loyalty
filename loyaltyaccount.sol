pragma solidity >=0.5.0<0.6.0;

contract accountCreator {

    event NewAccount (uint cpf, string name, uint id, uint points);
    event NewRestaurant (uint cnpj, uint id);

    uint private idg = 0;
    
    struct LoyaltyAccount {
        uint id;
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
    mapping(uint => uint) public cpfToId;

    function createAccount(string calldata _name, uint _cpf) external {
        uint _id = accounts.push(LoyaltyAccount(idg++, _name, 0, _cpf)) - 1;
        cpfToHolder[_cpf] = msg.sender;
        holderToCpf[msg.sender] = _cpf;
        cpfToId[_cpf] = _id;
        emit NewAccount(_id, _name, _cpf, 0);
    }

    function createRestaurant(string calldata _name, uint _cnpj) external {
        uint id = restaurants.push(Restaurant(_name, _cnpj)) - 1;
        cnpjToRestaurant[_cnpj] = msg.sender;
        emit NewRestaurant(id, _cnpj);
    }

    function getPoints(uint _cpf) external view returns (uint points) {
        uint _id = cpfToId[_cpf];
        return accounts[_id].points;
    }

    function addPoints(uint _cpf, uint pointsAdded) public {
        uint _id = cpfToId[_cpf];
        accounts[_id].points = accounts[_id].points + pointsAdded;
    }
}