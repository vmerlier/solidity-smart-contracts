pragma solidity ^0.4.0;

// Contract designed for fidelity point management

contract Points {

    address chairperson;
    Client[] clients;
    Cashier[]  cashiers;

    struct Client {
        address address_client;
        uint balance;
    }

    struct Cashier {
        address address_cashier;
    }
    
    
    // Initialise the chairperson of the contract
    function Points() {
        chairperson = msg.sender;
    }
    
    
    modifier isChairperson(){
        if(msg.sender != chairperson)
            throw; 
            _;
    }
    
    modifier isCashier(){
        for(uint i = 0; i < cashiers.length ; i++ ){
            if(cashiers[i].address_cashier == msg.sender)
            _;
        }throw;
    }

    
    function getBalance(uint _aIndex) isCashier() constant returns(uint) {
        return clients[_aIndex].balance;
    }


    // Allow to add a new Client to the list, can only be performed by cashier
    function addClient(address _aClient)  isCashier(){
        bool present = false;
        
        for(uint i = 0; i< clients.length ; i++){
            
            if(_aClient == clients[i].address_client){
                present = true;
            }
        }
        if(present)throw;
        else{
            clients.push(Client({address_client :_aClient, balance : 0}));
        }
    }
    
    
    // Add a new Cashier in the list of Cashier, only can be performed by chairperson 
    function addCashier(address _aCashier) isChairperson() {
        
        bool present = false;
        for(uint i = 0; i< cashiers.length ; i++){
            
            if(_aCashier == cashiers[i].address_cashier){
                present = true ;
            }
        }
        if(!present){
            cashiers.push(Cashier({address_cashier : _aCashier}));
        }
    }
    
    
	// Allow cashier to add point on user account 
    function addPoint(address _aClient, uint _aPoints) isCashier() {
        
        for(uint i  = 0 ; i < clients.length; i++){
                
            if(clients[i].address_client == _aClient){
                    
                clients[i].balance += _aPoints;
            }
            else{ throw; } 
        }
    } 
    
    // Allow Cashier to use point for future payments 
    // Only Cashier can perform the operation 
    function usePoint(address _aClient, uint _aPoints) isCashier() {
            
        for(uint i  = 0 ; i < clients.length; i++){
               
            if(clients[i].address_client == _aClient){
                    
                if( getBalance(i) > _aPoints){
                        
                    clients[i].balance = clients[i].balance - _aPoints;
                }else{
                    throw;
                }
                    
            }
        }
    }

    
    function balanceOf(address _aClient) isCashier() constant returns(uint){
        
        for(uint i  = 0 ; i < clients.length; i++){
            
            if(clients[i].address_client == _aClient){
                
               return getBalance(i);
            }
        }
        throw;
    }
    
   function kill() isChairperson() {
            suicide(msg.sender);
    }
    
}