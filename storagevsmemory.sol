// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 < 0.9.0;

contract A{
    string[] public cities = ['mumbai','pune'];

    function f_memory() public view{
        string[] memory s1 = cities;
        // string s2; --> error
        s1[0] = 'raipur';
    }

      function f_storage() public{
        string[] storage s1 = cities;
        // string s2; --> error
        s1[0] = 'raipur';
    }

}