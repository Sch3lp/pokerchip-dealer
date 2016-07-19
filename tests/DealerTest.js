let expect = require('chai').expect;
let {Dealer, Stack, PokerSet} = require('../app/dealer');

var myDealer = new Dealer();

describe('Dealer', () => {

	describe('Validation', () => {
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
	});
	
	describe('Distribution', () => {
		it('should provide a stack of at least 50 big blinds', () => {
		});
		it('1000 chips, 1 denomination, 10 players, 10 buy-in', () => {
			let chips = 1000;
			let players = 10;
			let stack = new Dealer(chips, 1, players, 10).distribute();
			expect(stack.denominations).to.deep.equal([10]);
			expect(stack.amounts).to.deep.equal([10]);
			expect(stack.totalValue).to.equal(100);
			expect(stack.totalValue * players).to.equal(chips);
		});
		// Full poker set big (8 different denoms); 500 chips
		// {
		// 	.25 :  75,
		// 	.50 :  75,
		// 	1   : 100,
		// 	5   : 100,
		// 	10  :  50,
		// 	25  :  50,
		// 	100 :  25,
		// 	500 :  25
		// }
		it('500 chips, 8 denominations, 1 player, 17406.25 buy-in', () => {
			let chips = 500;
			let players = 1;
			let buyin = 17406.25;
			let stack = new Dealer(chips, 8, players, buyin, .25).distribute();
			expect(stack.denominations).to.deep.equal([.25, .50, 1, 5, 10, 25, 100, 500]);
			expect(stack.amounts).to.deep.equal([75, 75, 100, 100, 50, 50, 25, 25]);
			expect(stack.totalChips).to.equal(chips);
			expect(stack.totalValue).to.equal(buyin);
			expect(stack.totalValue * players).to.equal(chips);
		});
		// Full poker set small (4 different denoms); 200 chips
		// {
		// 	.25 : 100,
		// 	.50 : 100,
		// 	1   :  50,
		// 	5   :  50
		// }
		it('200 chips, 2 denomination, 10 players, 10 buy-in', () => {
			let chips = 200;
			let players = 10;
			let stack = new Dealer(chips, 1, players, 10, 10).distribute();
			expect(stack.denominations).to.deep.equal([10,20]);
			expect(stack.amounts).to.deep.equal([10]);
			expect(stack.totalValue).to.equal(100);
			expect(stack.totalValue * players).to.equal(chips);
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
		it('totalValue returns the sum of value-amount pairs', () => {
			let stack = new Stack(
				[.25,75], //18.75
				[.50,75], //37.5
				[1,100],  //100
				[5,100],  //500
				[10,50],  //500
				[25,50],  //1250
				[100,25], //2500
				[500,25]  //12500
			);
			expect(stack.totalValue).to.deep.equal(17406.25);
		});
	});

	describe('PokerSet', () => {
		it('distributionPerColor without names returns distribution per color as numbers', () => {
			let set = new PokerSet(75, 75, 100, 100, 50, 50, 25, 25);
			expect(set.distributionPerColor).to.deep.equal([
				[1,75],
				[2,75],
				[3,100],
				[4,100],
				[5,50],
				[6,50],
				[7,25],
				[8,25]]
			);
		});
		it('distributionPerColor with names returns distribution per colors as names', () => {
			let set = new PokerSet(75,75,100,100,50,50,25,25);
			set.setColorNames('white','pink','red','green','blue','black','silver','gold');
			expect(set.distributionPerColor).to.deep.equal([
				['white',75],
				['pink',75],
				['red',100],
				['green',100],
				['blue',50],
				['black',50],
				['silver',25],
				['gold',25]]
			);
		});
		it('distributionPerColor with incomplete names returns distribution per colors with names and numbers', () => {
			let set = new PokerSet(75,75,100,100,50,50,25,25);
			set.setColorNames('white','pink','red','green','blue');
			expect(set.distributionPerColor).to.deep.equal([
				['white',75],
				['pink',75],
				['red',100],
				['green',100],
				['blue',50],
				[6,50],
				[7,25],
				[8,25]]
			);
		});
		it('setting distributionPerColor destructures correctly', () => {
			let set = new PokerSet(9000);
			set.distributionPerColor = [
				['white',75],
				['pink',75],
				['red',100],
				['green',100],
				['blue',50],
				['black',50],
				['silver',25],
				['gold',25]
			];
			expect(set.distributionPerColor).to.deep.equal([
				['white',75],
				['pink',75],
				['red',100],
				['green',100],
				['blue',50],
				['black',50],
				['silver',25],
				['gold',25]]
			);
			set.setColorNames('brown','yellow','white','orange','purple');
			expect(set.distributionPerColor).to.deep.equal([
				['brown',75],
				['yellow',75],
				['white',100],
				['orange',100],
				['purple',50],
				[6,50],
				[7,25],
				[8,25]]
			);
		});
	});

});
