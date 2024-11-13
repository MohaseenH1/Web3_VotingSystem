// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract VotingSystem{
    address immutable owner;
    uint  start; uint  end; uint highestvote=0;string winner;
    constructor(){
        owner=msg.sender;
        start=block.timestamp;
        end=start+ 7 days;
    }
    mapping(address=>bool) AuthorizedVoters; //list of votes
    mapping(address=>bool) VotersVoted; //list of voters voted
    mapping(string =>bool) PartiesList ;
    mapping(string=>uint) VotingCount;
    string[]  PartiesName;
   

     modifier OnlyAuthorizedVoter{
        require(AuthorizedVoters[msg.sender],"You Are Not Eligible for Voting");
        require(!VotersVoted[msg.sender],"You Have Already Used Your Vote");
        require(block.timestamp<end, "Election has been completed ");
        _;
    }
     
    modifier onlyOwner(){
        require(msg.sender==owner,"You are Not Authorized to make this call");
        _;
    }
    

    
    function Vote(string memory _party) public OnlyAuthorizedVoter{
        require(PartiesList[_party],"Party Name is not Available");
        VotingCount[_party]+=1;
        VotersVoted[msg.sender]=true;
       
        if(VotingCount[_party]>highestvote){
            highestvote=VotingCount[_party];
            winner=_party;
        }

    } 

    function result() public view  returns(uint _res,string memory _name){
        require(block.timestamp>end,"Election is still Ongoing");
        return (highestvote,winner);
    }

    function addparties(string memory _party) public onlyOwner{
        require(!PartiesList[_party],"Party Already Exist");
        PartiesName.push(_party);
        PartiesList[_party]=true;
    }
    function addVoters(address _Voters) public onlyOwner{
        require(!AuthorizedVoters[_Voters],"Voter is Already Eligible");
        AuthorizedVoters[_Voters]=true;
    }

   function partiesNames() public view returns(string[] memory ){
    return PartiesName;
   }


}
