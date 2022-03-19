pragma solidity >=0.5.0 <0.8.14;

/*
contrato para trackear fidelidade do cliente
1. existe um dono do estabelecimento, ele deve:
    - fornecer o contrato a um cliente -> como?
    - fornecer "creditos" de fidelidadee por compra -> giveReward
    - atualizar status do cliente a cada compra -> giveReward
    - não pode mudar créditos do cliente manualmente (apenas gerar trigger de aumento) -> ok
2. existe um cliente, ele:
    - compra algo e isso gera (conversão reais->créditos simples) créditos -> no front input, no sol giveReward + getCredits
    - pode consultar seus créditos a qualquer momento -> getBalance
    - não pode alterar seus créditos manualmente -> ok
    - pode usar um trigger para gastar os créditos (transação a ser aprovada pelo dono) -> useCredits
    Caso dê tempo:
    - pode transferir seus créditos a outras pessoas no blockchain
    - pode converter seus creditos em ether ("cashback")
*/
contract ClientLoyalty {

    struct LoyalClient {
        uint id;
        uint credits;
    }

    LoyalClient[] clients;

    mapping (uint => address) idToAddress;
    mapping (address => uint) addressToId;
    mapping (address => uint) ownerToCredits;

    function _getCreditsFromBuyValue(uint buyValue) internal pure returns (uint) {
        // logic to generate amount of reward to be gained
        return buyValue * 11 % 7;
    }

    function giveClientReward (uint _clientId, uint buyValue) external {
        // executa 1.1, 1.2, 1.3
        require(msg.sender == idToAddress[_clientId]);
        LoyalClient storage myClient;
        bool clientExists = false;
        for (uint i = 0; i < clients.length; i++) {
            if (clients[i].id == addressToId[msg.sender]) {
                myClient = clients[i];
                clientExists = true;
                break;
            }
        }
        if (clientExists) {
            // if clientExists, increase buys counting and credits;
            myClient.credits += _getCreditsFromBuyValue(buyValue);
        } else {
            // in case it is a new client, add client and his credits
            clients.push(LoyalClient(_clientId, 1, _getCreditsFromBuyValue(buyValue)));
        }
    }

    function getBalance(address _owner) external returns (uint) {
        require(msg.sender == _owner);
        return ownerToCredits[_owner];
    }

    function useCredits() {

    }
}