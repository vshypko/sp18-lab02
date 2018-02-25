pragma solidity 0.4.19;

import "./strings.sol";

contract Concatenate {
    using strings for *;
    string public s;

    function concat(string s1, string s2) returns (string) {
        return s1.toSlice().concat(s2.toSlice());
    }
}
