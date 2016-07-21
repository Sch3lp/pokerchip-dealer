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
		// amount of BBs in buy-in determines speed
		// 100 BBs as 2nd denom = slow
		// 50 BBs as 2nd denom = semi
		// 25 BBs as 2nd denom = fast

		// big blind should have biggest "weight" --> proportion of stack
		//10 * 0.05 = 0.5   0.22222
		//15 * 0.10 = 1.5   0.33333
		//12 * 0.25 = 3     0.26666
		// 6 * 0.5  = 3     0.13333
		// 2 * 1    = 2     0.04444

		// since there seem to be so many "rules" that can all have an impact,
		// but that you might not want to apply in a hardcore fashion all the time
		// it got me thinking of maybe representing all different aspects of a pokergame
		// i.e. chips, their denominations, their value, their actual value, the buy-in, the amount of players, ...
		// as rules (within a ruleset maybe)
		// that you can enforce or "impose" (softer).
		// so maybe I start over, yes?

		//pokerset
		//['white',75],['pink',75],['green',100],['brown',100],['blue',50]
		//denoms
		//[.05,.1,.25,.5,1]
		//set with denoms
		//[[.05,'white',75],[.1,'pink',75],[.25,'green',100],[.5,'brown',100]]

		let denoms = Helper.findIdealDenominations(this.pokerSet.amountOfColors, this.lowestDenom);
		let slicedDenoms = denoms.slice(0,idealAmountOfDenoms);
		
		// find denoms in the pokerset that have the highest amounts and assign to BB and BB+1
		// find next denom in pokerset and assign to SB
		// find next denom in pokerset and assign to BB+x
		// That way we should get which color is 

		let assignedChips = ColorPicker.smartpickColors(slicedDenoms, this.pokerSet);

		let chips = slicedDenoms.map((denom, idx) => [denom,
												this.pokerSet.distributionPerColor[idx][0],
		 										this.pokerSet.distributionPerColor[idx][1]
		 										]);
		return new Stack(slicedDenoms.map((nom) => [nom]));
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

