/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
let Helper = require('./helper');
let PokerSet = require('./pokerset');
module.exports = (() => {

class Dealer {

	constructor(totalAmountOfChips,
				amountOfDenoms,
				amountOfPlayers,
				buyIn,
				lowestDenom) {
		this.totalAmountOfChips = totalAmountOfChips;
		this.amountOfDenoms = amountOfDenoms;
		this.amountOfPlayers = amountOfPlayers;
		this.buyIn = buyIn;
		this.lowestDenom = lowestDenom;
		this.amountOfRebuys = 0;
	}

	deal() {
		let validationErrors = this.validateRequirements();
		return validationErrors || '';
	}

	distribute() {
		// amount of BBs in buy-in determines speed
		// 100 BBs as 2nd denom = slow
		// 50 BBs as 2nd denom = semi
		// 25 BBs as 2nd denom = fast
		let denoms = Helper.findIdealDenominations(this.amountOfDenoms, this.lowestDenom);
		denoms.map((denom) => [denom, ]);
		return new Stack([10,10]);
	}

	validateRequirements() {
		if (!this.totalAmountOfChips || this.totalAmountOfChips <= 0) {
			return 'I require a number of chips before dealing.';
 		}
 		if (!this.amountOfDenoms || this.amountOfDenoms <= 0) {
			return 'I require a number of possible chip denominations before dealing.';
 		}
 		if (!this.amountOfPlayers || this.amountOfPlayers <= 0) {
			return 'I require a number of players before dealing.';
 		}
 		if (!this.buyin || this.buyin <= 0) {
			return 'I require a buy-in (total value) before dealing.';
 		}
	}
}

class Stack {
	constructor(...distribution) {
		this.distribution = distribution; //2D array, denominations first
	}

	get denominations() {
		return this.distribution.map(([denomination,_]) => denomination);
	}

	get smallBlindDenomination() {
		return this.denominations[0];
	}

	get bigBlindDenomination() {
		return this.denominations[1];
	}

	get amounts() {
		return this.distribution.map(([_,amount]) => amount);
	}

	get totalChips() {
		return this.amounts.reduce((prev,cur) => prev + cur);
	}

	get totalValue() {
		return this.distribution.map(([denomination,amount]) => denomination * amount)
								.reduce(((prev, cur) => prev + cur), 0);
	}
}

return { Dealer, Stack };

})();

