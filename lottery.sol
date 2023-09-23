// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0;

contract lottery{
    //1) create manager and participants to enter in lottery 

    address public manager; // there is an single manager who controll full contract over lottery

    /*more then one participants are pariticipate in lottery 
    thats why participants should be an dynamic array*/
    address payable[] public participants; //

    //2) make the manager to full controll balance and visibility
    constructor(){
        manager= msg.sender; // global variable us use to define manager
    }

    //3) create payable and registration function
    receive() external payable{
    // 5) Checking the enough value availibility
        // check if the participants have enough ether to participate the 
        require(msg.value>=1 ether);

        // every time when a participant pay in ether then he is registered with lottey         
        participants.push(payable(msg.sender));
    } 

    //4) Checking and returning the lottery balance 
    function getBalance()public view returns(uint){
        require(msg.sender == manager);

        // checking the total balance in the contract
        return address(this).balance;
    }
// 6) this function converting the contact to a random hash address with(keccak256)standard
    function random()public view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }
/* selectWinner function choose winner by manager if 
there is minimum 3 participatents randomly and the
winner's address is payble with all the total balance 
in the contract and after that the participants list should be ZERO by default */
    function selectWinner() public returns(address){
        require(msg.sender == manager);
        require(participants.length >= 3);
        uint r = random();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable [](0);
        return winner;
    }

}
