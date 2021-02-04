pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
    string public name = "Dapp Token Farm";
    address public owner;
    DappToken public dappToken;
    DaiToken public daiToken;

    address[] public stakers;
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(DappToken _daapToken, DaiToken _daiToken) public {
        dappToken = _daapToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    function stakeTokens(uint256 _amount) public {
        require(_amount > 0, "amount cannot be 0");

        daiToken.transferFrom(msg.sender, address(this), _amount);
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    function issueTokens() public {
        require(msg.sender == owner, "caller must be the owner");
        for (uint256 i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];
            uint256 balance = stakingBalance[recipient];
            if (balance > 0) {
                dappToken.transfer(recipient, balance);
            }
        }
    }

    function unstakeTokens() public {
        uint256 balance = stakingBalance[msg.sender];

        require(balance > 0, "balance should be more than 0");

        daiToken.transfer(msg.sender, balance);

        stakingBalance[msg.sender] = 0;

        isStaking[msg.sender] = false;
    }
}
