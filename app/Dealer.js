/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
let Helper = require('./helper');
let Stack = require('./stack');
let PokerSet = require('./pokerset');
let ColorPicker = require('./colorpicker');

module.exports = (() => {

const idealAmountOfDenoms = 5;

class Dealer {
	constructor(pokerSet,
				amountOfPlayers,
				buyIn,
				lowestDenom) {
		this.pokerSet = pokerSet;
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
		let denoms = Helper.findIdealDenominations(this.pokerSet.amountOfColors, this.lowestDenom);
		let limitedDenoms = denoms.slice(0,idealAmountOfDenoms);

		let assignedChips = ColorPicker.smartpickColors(limitedDenoms, this.pokerSet.distributionPerColor);

		return new Stack(limitedDenoms.map((nom) => [nom]));
	}

	validateRequirements() {
		if (!this.pokerSet || !PokerSet.prototype.isPrototypeOf(this.pokerSet)) {
			return 'I require a PokerSet before dealing.';
		}
		if (this.pokerSet.validate()) {
			return this.pokerSet.validate();
		}
 		if (!this.amountOfPlayers || this.amountOfPlayers <= 0) {
			return 'I require a number of players before dealing.';
 		}
 		if (!this.buyIn || this.buyIn <= 0) {
			return 'I require a buy-in (total value) before dealing.';
 		}
 		if (!this.lowestDenom || this.lowestDenom <= 0) {
			return 'I require a lowest denomination before dealing.';
 		}
 		return '';
	}
}

return Dealer;

})();

