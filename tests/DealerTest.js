let expect = require('chai').expect;
let {Dealer} = require('../app/dealer');

var myDealer = new Dealer();

describe('Dealer', () => {
	it('requires a number of chips', () => {
		let dealer = new Dealer();
		expect(dealer.deal()).to.equal('I require a number of chips before dealing.');
		dealer = new Dealer(0);
		expect(dealer.deal()).to.equal('I require a number of chips before dealing.');
	});
	it('requires an amount of possible values of chips', () => {
		let dealer = new Dealer(10,0,0,0);
		expect(dealer.deal()).to.equal('I require a number of possible chip values before dealing.');
		dealer = new Dealer(10);
		expect(dealer.deal()).to.equal('I require a number of possible chip values before dealing.');
	});
	it('requires an amount of players', () => {
		let dealer = new Dealer(10,10);
		expect(dealer.deal()).to.equal('I require a number of players before dealing.');
		dealer = new Dealer(10,10,0,0);
		expect(dealer.deal()).to.equal('I require a number of players before dealing.');
	});
	it('requires a buy-in', () => {
		let dealer = new Dealer(10,10,10);
		expect(dealer.deal()).to.equal('I require a buy-in (total value) before dealing.');
		dealer = new Dealer(10,10,10,0);
		expect(dealer.deal()).to.equal('I require a buy-in (total value) before dealing.');
	});
});
