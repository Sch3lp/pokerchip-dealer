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
		if (!this.totalAmountOfChips || this.totalAmountOfChips <= 0) {
			return 'I require a number of chips before dealing.';
 		}
 		if (!this.amountOfPossibleValues || this.amountOfPossibleValues <= 0) {
			return 'I require a number of possible chip values before dealing.';
 		}

		return '';
	}
}

return { Dealer };

})();

