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
	it('requires an amount of possible denominations of chips', () => {
		let dealer = new Dealer(10,0,0,0);
		expect(dealer.deal()).to.equal('I require a number of possible chip denominations before dealing.');
		dealer = new Dealer(10);
		expect(dealer.deal()).to.equal('I require a number of possible chip denominations before dealing.');
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
		it('1000 chips, 1 denomination, 10 players, 10 buy-in', () => {
			let chips = 1000;
			let players = 10;
			let stack = new Dealer(chips, 1, players, 10).distribute();
			expect(stack.denominations).to.deep.equal([10]);
			expect(stack.amounts).to.deep.equal([10]);
			expect(stack.totalPerPlayer).to.equal(100);
			expect(stack.totalPerPlayer * players).to.equal(chips);
		});
		// it('1000 chips, 5 denominations, 1 player, 10 buy-in', () => {
		// });
		// it('distribution with 100 chips, 5 values, 9 players, 10 buy-in', () => {
		// });
		// it('distribution with 100 total chips, 5 values, 6 players, 10 buy-in', () => {
		// });
	});

	describe('Stack', () => {
		it('denominations returns all the different denominations', () => {
			let stack = new Stack([1,10],[2,20],[3,45]);
			expect(stack.denominations).to.deep.equal([1,2,3]);
		});
		it('amounts returns all the different amounts', () => {
			let stack = new Stack([1,10],[2,20],[3,45]);
			expect(stack.amounts).to.deep.equal([10,20,45]);
		});
		it('totalPerPlayer returns the sum of value-amount pairs', () => {
			let stack = new Stack([1,10],[2,20],[3,45]);
			expect(stack.totalPerPlayer).to.deep.equal(185);
		});
	});

});
