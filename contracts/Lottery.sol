// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public participants;
    address payable public winner;

    constructor()
    {
        manager = msg.sender;//when we compile and deploy the contract from that particular account it will be stored on the manager hence it will gain control of the contract
    }

    receive() external payable{
        require(msg.value == 1 ether,"Please play 1 ether");
        participants.push(payable(msg.sender));
    }
    function getBalance() public view returns(uint){
        require(msg.sender== manager);
        return address(this).balance;
    }
    //randomly select participants
    function random() internal view returns(uint){
      return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,participants.length)));
    }
    //selecting winnner //fetching array index
    function selectWinnner() public{
        require(msg.sender == manager);
        require(participants.length>=3,"players are less than 3");
        uint r = random();
        // address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants= new address payable[](0);
    }
    function allparticipants() public view returns(address payable[] memory){
        return participants;
    }
}

// 0x8f04aF00F965Ce97E58fD185E24609c409183478