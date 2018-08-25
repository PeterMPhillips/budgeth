pragma solidity ^0.4.24;

import './SafeMath.sol';

contract Budget{
  using SafeMath for uint;

  address private owner;
  address[] private accounts;
  mapping(address => uint) private percentage;

  constructor(address[] _addresses, uint[] _percentages)
  public {
    //require(_addresses.length == _percentages.length);
    owner = msg.sender;

    uint percentTotal = 0;
    for(uint8 i=0; i<_percentages.length; i++){
      percentTotal = percentTotal.add(_percentages[i]);
      accounts.push(_addresses[i]);
      percentage[_addresses[i]] = _percentages[i];
    }
    //assert(percentTotal == 100);
  }

  function distributeFunds()
  external
  onlyBy(owner){
    require(address(this).balance > 0);
    uint total = address(this).balance;
    for(uint8 i=0; i<accounts.length; i++){
      uint amount = total.getFractionalAmount(percentage[accounts[i]]);
      accounts[i].transfer(amount);
    }
  }

  function checkFunds()
  view
  external
  onlyBy(owner)
  returns(uint){
    return address(this).balance;
  }

  function updateBudget(address[] _addresses, uint[] _percentages)
  external
  onlyBy(owner){
    require(_addresses.length == _percentages.length);
    accounts.length = 0;
    uint percentTotal = 0;
    for(uint8 i=0; i<_percentages.length; i++){
      percentTotal = percentTotal.add(_percentages[i]);
      accounts.push(_addresses[i]);
      percentage[_addresses[i]] = _percentages[i];
    }
    assert(percentTotal == 100);
  }

  function withdraw(uint _amount) public onlyBy(owner){
      require(address(this).balance >= _amount);
      owner.transfer(_amount);
  }

  function kill() public onlyBy(owner){
    selfdestruct(owner);
    //Maybe allow kill to be called by any address in the template?
  }

  function() public payable{}

  modifier onlyBy(address _account){
    require(msg.sender == _account,"Sender not authorized.");
    _;
  }
}
