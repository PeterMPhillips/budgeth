var BigNumber = require('bignumber.js');

const Budget = artifacts.require("./Budget.sol");

const ETH = 1000000000000000000;

contract('Budget Contract', async() => {
  const hardwareWallet = web3.eth.accounts[0];
  const coldWallet = web3.eth.accounts[1];
  const phone = web3.eth.accounts[2];
  const trading = web3.eth.accounts[3];
  const bank = web3.eth.accounts[4];
  const cash = web3.eth.accounts[5];
  const payer = web3.eth.accounts[9];

  const addresses = [hardwareWallet, coldWallet, phone, trading, bank, cash];
  const percentages = [30, 20, 5, 10, 20, 15];

  let budget;

  it('Deploy contract', async() => {
    budget = await Budget.new(addresses, percentages);
  });

  it('Send money', async() => {
    await web3.eth.sendTransaction({
      from: payer,
      to: budget.address,
      value: 10*ETH
    });

    assert.equal(await budget.checkFunds(), 10*ETH);
  });

  it('Distribute funds', async() => {
    let balanceBefore = [];
    for(var i=0; i<addresses.length; i++){
      balanceBefore.push(await web3.eth.getBalance(addresses[i]));
    }
    await budget.distributeFunds();

    for(var i=0; i<addresses.length; i++){
      let balance = BigNumber(await web3.eth.getBalance(addresses[i]));
      let payment = balance.minus(balanceBefore[i]);
      console.log('Money received: ' + payment);
      //assert.equal()
    }
  });


});
