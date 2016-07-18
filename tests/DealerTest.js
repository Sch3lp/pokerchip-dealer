let expect = require('chai').expect;
let {Dealer, Stack} = require('../app/dealer');

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
	
	describe('distribute', () => {
		let dealer;
		it('1000 chips, 1 value, 10 players, 10 buy-in', () => {
			let stack = new Dealer(1000, 1, 10, 10).distribute();
			expect(stack).to.deep.equal(new Stack([10,10]));
			expect(stack.values).to.deep.equal([10]);
			expect(stack.amounts).to.deep.equal([10]);
			expect(stack.totalValuePerPlayer).to.deep.equal(100);
		});
		// it('distribution with 100 chips, 5 values, 9 players, 10 buy-in', () => {
		// 	dealer = new Dealer(100,5,9,10);
		// 	expect(dealer.distribute()).to.deep.equal(new Stack(.5,.10,.25,.50,1));
		// });
		// it('distribution with 100 total chips, 5 values, 6 players, 10 buy-in', () => {
		// 	dealer = new Dealer(100,5,6,10);
		// 	expect(dealer.distribute()).to.deep.equal(new Stack(.5,.10,.25,.50,1));
		// });
	});

	describe('Stack', () => {
		it('values returns all the different values', () => {
			let stack = new Stack([1,10],[2,20],[3,45]);
			expect(stack.values).to.deep.equal([1,2,3]);
		});
		it('amounts returns all the different amounts', () => {
			let stack = new Stack([1,10],[2,20],[3,45]);
			expect(stack.amounts).to.deep.equal([10,20,45]);
		});
		it('totalValuePerPlayer returns the sum of value-amount pairs', () => {
			let stack = new Stack([1,10],[2,20],[3,45]);
			expect(stack.totalValuePerPlayer).to.deep.equal(185);
		});
	});

});
