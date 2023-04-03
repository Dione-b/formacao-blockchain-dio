// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

import "./IERC20.sol";

contract BToken is IERC20 {

    string public constant name = "BToken";
    string public constant symbol = "BT";

    mapping (address => uint256) balances;
    mapping(address => mapping(address=>uint256)) allowed;
    uint256 totalSupply_ = 5 ether;

    constructor() 
    {
        balances[msg.sender] = totalSupply_;
    }

    function decimals() public pure returns (uint8)
    {
        return 18;
    }

    function totalSupply() 
        public 
        override 
        view 
        returns (uint256) 
    {
        return totalSupply_;
    }

    function balanceOf(
        address tokenOwner
    ) 
        public 
        override 
        view 
        returns (uint256)
    {
        return balances[tokenOwner];
    }

    function transfer(
        address receiver, 
        uint256 numTokens
    ) 
        public 
        override 
        returns (bool) 
     {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(
        address delegate, 
        uint256 numTokens
    ) 
        public 
        override 
        returns (bool) 
    {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(
        address owner, 
        address delegate
    ) 
        public 
        override 
        view 
        returns (uint) 
    {
        return allowed[owner][delegate];
    }

    function transferFrom(
        address owner, 
        address buyer, 
        uint256 numTokens
    ) 
        public 
        override 
        returns (bool) 
    {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}