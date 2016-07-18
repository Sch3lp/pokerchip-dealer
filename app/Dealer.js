/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */

module.exports = (() => {

class Dealer {
	constructor(totalAmountOfChips, amountOfPossibleValues, amountOfPlayers, buyIn) {
		this.totalAmountOfChips = totalAmountOfChips;
		this.amountOfPossibleValues = amountOfPossibleValues;
		this.amountOfPlayers = amountOfPlayers;
		this.buyIn = buyIn;
		this.amountOfRebuys = 0;
	}

	deal() {
		let validationErrors = this.validateRequirements();
		return !validationErrors ? '' : validationErrors;
	}

	distribute() {
		return new Stack([10,10]);
	}

	validateRequirements(){
		if (!this.totalAmountOfChips || this.totalAmountOfChips <= 0) {
			return 'I require a number of chips before dealing.';
 		}
 		if (!this.amountOfPossibleValues || this.amountOfPossibleValues <= 0) {
			return 'I require a number of possible chip values before dealing.';
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
	constructor(...distribution){
		this.distribution = distribution; //2D array, values first
	}

	get values() {
		return this.distribution.map(([value,_]) => value);
	}

	get amounts() {
		return this.distribution.map(([_,amount]) => amount);
	}

	get totalValuePerPlayer() {
		return this.distribution.map(([value,amount]) => value * amount)
								.reduce(((prev, cur) => prev + cur), 0);
	}
}

return { Dealer, Stack };

})();

