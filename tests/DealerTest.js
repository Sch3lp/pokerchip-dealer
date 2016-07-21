let expect = require('chai').expect;
let Dealer = require('../app/dealer');
let Stack = require('../app/stack');
let PokerSet = require('../app/pokerset');

var myDealer = new Dealer();
function ignore(){}

describe('Dealer', () => {

	describe('Validation', () => {
		let validPokerSet = new PokerSet(20,20);
		let dummyPokerSet = new PokerSet(); 
		dummyPokerSet.validate = () => 'pokerset validation';
		it('requires a PokerSet', () => {
			let dealer = new Dealer();
			expect(dealer.deal()).to.equal('I require a PokerSet before dealing.');
		});
		it('requires a PokerSet', () => {
			let dealer = new Dealer('fish',10,10,10);
			expect(dealer.deal()).to.equal('I require a PokerSet before dealing.');
		});
		it('validates PokerSet when validating', () => {
			let dealer = new Dealer(dummyPokerSet,0,0,0);
			expect(dealer.deal()).to.equal('pokerset validation');
		});
		it('requires an amount of players', () => {
			let dealer = new Dealer(validPokerSet);
			expect(dealer.deal()).to.equal('I require a number of players before dealing.');
			dealer = new Dealer(validPokerSet,0,0,0);
			expect(dealer.deal()).to.equal('I require a number of players before dealing.');
		});
		it('requires a buy-in', () => {
			let dealer = new Dealer(validPokerSet,10);
			expect(dealer.deal()).to.equal('I require a buy-in (total value) before dealing.');
			dealer = new Dealer(validPokerSet,10,0,0);
			expect(dealer.deal()).to.equal('I require a buy-in (total value) before dealing.');
		});
		it('requires a lowest denomination', () => {
			let dealer = new Dealer(validPokerSet,11,12);
			expect(dealer.deal()).to.equal('I require a lowest denomination before dealing.');
			dealer = new Dealer(validPokerSet,11,12,0);
			expect(dealer.deal()).to.equal('I require a lowest denomination before dealing.');
		});
	});
	
	describe('Distribution', () => {
		let largePokerSet = new PokerSet();
		largePokerSet.distributionPerColor = [
			['purple',75],
			['orange',75],
			['white-red',100],
			['red-blue',100],
			['blue-white',50],
			['green-pink',50],
			['black-salmon',25],
			['purple-pink',25]
		];
		it('limits the amount of denoms to 5', () => {
			let dealer = new Dealer(largePokerSet, 6, 10, .05);
			let stack = dealer.distribute();
			expect(stack.denominations).to.deep.equal([.05, .1, .25, .5, 1]);
		});
		it('should provide a stack of at least 50 big blinds', () => {
		});
	});

	ignore('Scenarios', () => {
		it('with 1000 chips, 1 denomination, 10 players, 10 buy-in', () => {
			let chips = 1000;
			let players = 10;
			let stack = new Dealer(chips, 1, players, 10).distribute();
			expect(stack.denominations).to.deep.equal([10]);
			expect(stack.amounts).to.deep.equal([10]);
			expect(stack.totalValue).to.equal(100);
		});
		it('with 500 chips, 8 denominations, 1 player, 17406.25 buy-in', () => {
			let chips = 500;
			let players = 1;
			let buyin = 17406.25;
			let stack = new Dealer(chips, 8, players, buyin, .25).distribute();
			expect(stack.denominations).to.deep.equal([.25, .50, 1, 5, 10, 25, 100, 500]);
			expect(stack.amounts).to.deep.equal([75, 75, 100, 100, 50, 50, 25, 25]);
			expect(stack.totalChips).to.equal(chips);
			expect(stack.totalValue).to.equal(buyin);
		});
		it('with 200 chips, 4 denominations, 1 player, 375 buy-in', () => {
			let chips = 200;
			let players = 1;
			let buyin = 375;
			let stack = new Dealer(chips, 8, players, buyin, .25).distribute();
			expect(stack.denominations).to.deep.equal([.25, .50, 1, 5]);
			expect(stack.amounts).to.deep.equal([100, 100, 50, 50]);
			expect(stack.totalChips).to.equal(chips);
			expect(stack.totalValue).to.equal(buyin);
		});
		it('with 200 chips, 2 denominations, 10 players, 10 buy-in', () => {
			let chips = 200;
			let players = 10;
			let stack = new Dealer(chips, 1, players, 10, 10).distribute();
			expect(stack.denominations).to.deep.equal([10,20]);
			expect(stack.amounts).to.deep.equal([10]);
			expect(stack.totalValue).to.equal(100);
		});
		it('with large pokerset of 500/8 chips, 5 denominations, 6 players, 10 buy-in', () => {
			let players = 6;
			let buyin = 10;
			let stack = new Dealer(largePokerSet, players, buyin, .05).distribute();
			expect(stack.denominations).to.deep.equal([.05, .10, .25, .50, 1]);
			expect(stack.amounts).to.deep.equal([10, 15, 12, 6, 2]);
			expect(stack.totalChips).to.equal(55);
			expect(stack.totalValue).to.equal(buyin);
		});
	});
});
