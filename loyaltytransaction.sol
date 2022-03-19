pragma solidity >=0.8.0<0.9.0;
import "./loyaltyaccount.sol";

contract LoyaltyTransaction is accountCreator {

    uint8 pointsPerHundredCoins = 10;

    modifier isRestaurant (uint _cnpj) {
        require (msg.sender == cnpjToRestaurant[_cnpj]);
        _;
    }

    function setPointPerCash (uint8 _newPointRule, uint _cnpj) external isRestaurant(_cnpj) { 
        pointsPerHundredCoins = _newPointRule;
    }

    function getPoints (uint _transactionValue, uint _cpf, uint _cnpj) external isRestaurant(_cnpj) {
        uint newPoints = pointsPerHundredCoins * _transactionValue / 100;
        addPoints(_cpf, newPoints);
    }

    function spendPoints (uint _cpf, uint _pointsTaken, uint _cnpj) external isRestaurant(_cnpj) {
        accounts[_cpf].points -= _pointsTaken;
    }
}