// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 < 0.9.0;

// create a datatype using struct
struct Instructor{
    uint age;
    string name;
    address add;
}

contract Academy{
    // create variable using struct datatype
    Instructor public academyInstructor;

    // enum used to define certain custom validation 
    // declaring a new enum type
    enum State {Open,Closed,Unkown}
    // declaring and initializing a new state variable of type State
    State public academyState = State.Open;

    // initializing the struct in the constructor
    constructor(uint _age, string memory _name){
        academyInstructor.age =_age;
        academyInstructor.name = _name;
        academyInstructor.add = msg.sender;
    }

    // changing there properties by using local memory 
    function changeInstructor(uint _age, string memory _name, address _add) public {
        if(academyState == State.Open){
            Instructor memory myInstructore = Instructor({
            age: _age,
            name: _name,
            add: _add
        });
        // all the properties are changes when academyInstructor takes properties of my local myInstructor
        academyInstructor = myInstructore;
        }
    }
}

contract School{
    Instructor  public schoolInstructor;
}