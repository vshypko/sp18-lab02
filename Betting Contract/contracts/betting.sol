pragma solidity ^0.4.19;


contract Betting {
    /* Constructor function, where owner and outcomes are set */
    function Betting(uint[] _outcomes) public {
        owner = msg.sender;
        for (uint i = 0; i < _outcomes.length; i++) {
            outcomes[i] = _outcomes[i];
        }
    }

    /* Fallback function */
    function() public payable {
        revert();
    }

    /* Standard state variables */
    address public owner;
    address public gamblerA;
    address public gamblerB;
    address public oracle;

    /* Structs are custom data structures with self-defined parameters */
    struct Bet {
        uint outcome;
        uint amount;
        bool initialized;
    }

    /* Keep track of every gambler's bet */
    mapping (address => Bet) bets;
    /* Keep track of every player's winnings (if any) */
    mapping (address => uint) winnings;
    /* Keep track of all outcomes (maps index to numerical outcome) */
    mapping (uint => uint) public outcomes;

    /* Add any events you think are necessary */
    event BetMade(address gambler);
    event BetClosed();

    /* Uh Oh, what are these? */
    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }

    modifier oracleOnly() {
        require(msg.sender == oracle);
        _;
    }

    modifier outcomeExists(uint outcome) {
        bool _exists = false;
        for (uint i = 0; i < 2; i++){
            if (outcomes[i] == outcome) {
                _exists = true;
                break;
            }
        }
        require(_exists == true);
        _;
    }

    /* Owner chooses their trusted Oracle */
    function chooseOracle(address _oracle) public ownerOnly() returns (address) {
        oracle = _oracle;
        return oracle;
    }

    /* Gamblers place their bets, preferably after calling checkOutcomes */
    function makeBet(uint _outcome) public payable returns (bool) {
        if (bets[msg.sender].amount != 0) {
            return false;
        }
        bets[msg.sender] = Bet(_outcome, msg.value, true);
        BetMade(msg.sender);
        if (gamblerA == address(0)) {
            gamblerA = msg.sender;
        } else if (gamblerB == address(0)) {
            gamblerB = msg.sender;
            BetClosed();
        }
        return true;
    }

    /* The oracle chooses which outcome wins */
    function makeDecision(uint _outcome) public oracleOnly() outcomeExists(_outcome) {
        uint totalPrize = bets[gamblerA].amount + bets[gamblerB].amount;
        if ((bets[gamblerA].outcome == bets[gamblerB].outcome)
            && (bets[gamblerA].outcome == _outcome)) {
            gamblerA.transfer(bets[gamblerA].amount);
            gamblerB.transfer(bets[gamblerB].amount);
        } else if (bets[gamblerA].outcome == bets[gamblerB].outcome) {
            oracle.transfer(totalPrize);
        } else if (bets[gamblerA].outcome == _outcome) {
            winnings[gamblerA] += totalPrize;
        } else if (bets[gamblerB].outcome == _outcome) {
            winnings[gamblerB] += totalPrize;
        }

        delete gamblerA;
        delete gamblerB;
    }

    /* Allow anyone to withdraw their winnings safely (if they have enough) */
    function withdraw(uint withdrawAmount) public returns (uint) {
        address account = msg.sender;
        if (withdrawAmount <= this.balance) {
            winnings[account] -= withdrawAmount;
            account.transfer(withdrawAmount);
            return withdrawAmount;
        } else {
            return 0;
        }
    }

    /* Allow anyone to check the outcomes they can bet on */
    function checkOutcomes(uint outcome) public view returns (uint) {
        return outcomes[outcome];
    }

    /* Allow anyone to check if they won any bets */
    function checkWinnings() public view returns(uint) {
        return winnings[msg.sender];
    }

    /* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
    function contractReset() public ownerOnly() {
        delete gamblerA;
        delete gamblerB;
        delete oracle;
    }
}
