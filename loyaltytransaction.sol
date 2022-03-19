pragma solidity >=0.8.0<0.9.0;
import "./loyaltyaccount.sol";

contract LoyaltyTransaction is accountCreator {

    uint8 pointsPerHundredCoins = 10;
    event newReward (uint cpf, string Reward);

    modifier isRestaurant (uint _cnpj) {
        require (msg.sender == cnpjToRestaurant[_cnpj]);
        _;
    }

    function setPointPerCash (uint8 _newPointRule, uint _cnpj) external isRestaurant(_cnpj) { 
        pointsPerHundredCoins = _newPointRule;
    }

    function sumPoints (uint _transactionValue, uint _cpf) external {
        uint newPoints = pointsPerHundredCoins * _transactionValue / 100;
        addPoints(_cpf, newPoints);
    }

    function spendPoints (uint _cpf, uint _pointsTaken) internal {
        accounts[_cpf].points -= _pointsTaken;
    }

    function collectReward (uint _cpf, uint _rewardPrice, string memory _reward) external {
        require (msg.sender == cpfToHolder[_cpf]);
        spendPoints (_cpf, _rewardPrice);
        emit newReward(_cpf, _reward);
    }
}