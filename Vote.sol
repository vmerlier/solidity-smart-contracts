
pragma solidity ^0.4.0;
contract Vote {

    address chairperson;
    Voter[] voters;
    Proposal[]  proposals;

    struct Voter {
        bool voted;
        address addresse;
        uint vote;
    }

    struct Proposal {
        uint voteCount;
        bytes32 name;
    }
    
    function Vote() {
        chairperson = msg.sender;
    }
    
    modifier isChairperson(){
        if(msg.sender != chairperson)
            throw; 
            _;
    }
    
    modifier isVoter(){
        for(uint i = 0; i < voters.length ; i++ ){
            if(voters[i].addresse == msg.sender)
            _;
        }throw;
    }
    
    // Allow voters to vote, take in argument the proposal
    function letsVote(uint _aProposal) {
        for(uint i = 0; i< voters.length ; i++){
            if(msg.sender == voters[i].addresse){
                if(voters[i].voted) throw;
                voters[i].voted = true;
                proposals[_aProposal].voteCount += 1;
                voters[i].vote = _aProposal;
            }
        }
    }

    // Allow to add a new voter to the voters tab this operation can be only
    // perform by the chairman, the voter mustn't being already present in the tab
    // Takes in parameter the address of the voter
    function addVoter(address _aNewVoter) isChairperson(){
        bool present = false;
        for(uint i = 0; i< voters.length ; i++){
            if(_aNewVoter == voters[i].addresse){
                present = true ;
            }
        }
        if(!present){
            voters.push(Voter({voted : false, addresse : _aNewVoter, vote : 0 }));
        }
    }

    // Allow to add a new proposal to proposals tab this operation can be only
    // perform by the chairman
    // Takes in parameter the name of the proposal
	
    function addProposal(bytes32 _aNewProposal) isChairperson() {
        bool present = false;
        for(uint i = 0; i< proposals.length ; i++){
            if(_aNewProposal == proposals[i].name){
                throw;  
            } 
            else{
                proposals.push( Proposal({name : _aNewProposal , voteCount : 0 }));
            }
        }
    }

    function winningProposal() constant returns (uint){
        if (msg.sender != chairperson) throw;
        else{
            uint winningVoteCount = 0;
            for (uint i = 0; i < proposals.length; i++) {
                if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
               }
            return i;
            }
        }
    }
    
     
    function kill() isChairperson(){
            suicide(chairperson);
    }
}