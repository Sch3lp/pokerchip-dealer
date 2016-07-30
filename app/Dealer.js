/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {

let Helper = require('./helper'),
    Stack = require('./stack'),
    PokerSet = require('./pokerset'),
    ColorPicker = require('./colorpicker'),
    KnapsackSolver = require('./knapsacksolver').KnapsackSolver;

const idealAmountOfDenoms = 5;

class Dealer {
	constructor(pokerSet,
				players,
				buyIn,
				lowestDenom) {
		this.pokerSet = pokerSet;
		this.players = players;
		this.buyIn = buyIn;
		this.lowestDenom = lowestDenom;
		this.amountOfRebuys = 0;
	}

	deal() {
		return validateRequirements(this) || this.distribute();
	}

	distribute() {
		let denoms = Helper.findIdealDenominations(this.pokerSet.amountOfColors, this.lowestDenom);
		let limitedDenoms = denoms.slice(0,idealAmountOfDenoms);
		let assignedChips = ColorPicker.smartpickColors(limitedDenoms, this.pokerSet.distributionPerColor);

		let stackChips = new KnapsackSolver(assignedChips, this.players).solve(this.buyIn);
		return new Stack(stackChips);
	}

}

function validateRequirements(dealer) {
	if (!dealer.pokerSet || !PokerSet.prototype.isPrototypeOf(dealer.pokerSet)) {
		return 'I require a PokerSet before dealing.';
	}
	if (dealer.pokerSet.validate()) {
		return dealer.pokerSet.validate();
	}
	if (!dealer.players || dealer.players <= 0) {
	return 'I require a number of players before dealing.';
	}
	if (!dealer.buyIn || dealer.buyIn <= 0) {
	return 'I require a buy-in (total value) before dealing.';
	}
	if (!dealer.lowestDenom || dealer.lowestDenom <= 0) {
	return 'I require a lowest denomination before dealing.';
	}
	return '';
}

return { Dealer, validateRequirements };

})();

