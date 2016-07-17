let expect = require('chai').expect;
let {Dealer} = require('../app/dealer');

var myDealer = new Dealer();

describe('Dealer', () => {
	it('requires a number of chips', () => {
		let dealer = new Dealer();
		expect(dealer.deal(6)).to.equal('I require a number of chips before dealing.');
	});
	it('requires an amount of possible values of chips', () => {
		let dealer = new Dealer(10,0,0,0);
		expect(dealer.deal(6)).to.equal('I require a number of possible chip values before dealing.');
	});
});
