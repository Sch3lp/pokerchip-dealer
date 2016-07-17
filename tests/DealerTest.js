let expect = require('chai').expect;
let {Dealer} = require('../app/dealer');

var myDealer = new Dealer();

describe('Dealer', () => {
	it('requires a number of chips', () => {
		let dealer = new Dealer();
		expect(dealer.deal(6)).to.equal('Number of chips required before dealing!');
	});
});
