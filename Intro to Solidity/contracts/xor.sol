pragma solidity 0.4.19;


contract XOR {
    function xor(string num1, string num2) public returns (string) {
        bytes memory _num1 = bytes(num1);
        bytes memory _num2 = bytes(num2);
        bytes memory xored = new bytes(_num1.length);

        require(_num1.length == _num2.length);

        for (uint i = 0; i < _num1.length; i ++) {
            if (((_num1[i] == "0") && (_num2[i] == "0"))
            || ((_num1[i] == "1") && (_num2[i] == "1"))) {
                xored[i] = "0";
            }
            else if (((_num1[i] == "0") && (_num2[i] == "1"))
            || ((_num1[i] == "1") && (_num2[i] == "0"))) {
                xored[i] = "1";
            }
            else {
                return;
            }
        }

        return string(xored);
    }
}
