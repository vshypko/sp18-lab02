pragma solidity 0.4.19;


contract Fibonacci {
    // assuming the sequence starts at 0
    function fibonacci(int n) public view returns (int) {
        int secondToLast = 0;
        int last = 1;
        int result;

        for (int i = 0; i < n - 2; ++i) {
            result = secondToLast + last;
            secondToLast = last;
            last = result;
        }

        return result;
    }
}
