/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */

module.exports = (() => {

class Dealer {
	constructor(totalAmountOfChips, amountOfPossibleValues, amountOfPlayers, buyIn) {
		this.totalAmountOfChips = totalAmountOfChips;
		this.amountOfPossibleValues = amountOfPossibleValues;
		this.amountOfPlayers = amountOfPlayers;
		this.buyIn = buyIn;
	}

	deal() {
		let validationErrors = this.validateRequirements();
		return !validationErrors ? '' : validationErrors;
	}

	distribute() {
		return new DistributionValues(.5,.10,.25,.50,1);
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

class DistributionValues {
	constructor(...valueSet){
		this.valueSet = valueSet;
	}
}

return { Dealer, DistributionValues };

})();

