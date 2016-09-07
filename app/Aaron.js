/* jshint undef: true, unused: false, esnext: true, strict:false, laxbreak:true */
/* globals module, require */
module.exports = (() => {

let _ = require('lodash');
let BigNumber = require('bignumber.js')

/* 
 * Aaron's algorithm
 */
class AaronAlg {

	// chip: { color, amount }
	// enriched: { color, amount, max }
	constructor(chipsPerColor, players) {
		this.sortedChipsPerColor = enrich(chipsPerColor, players)
			.sort((chipA, chipB) => chipB.max - chipA.max);
		this.colors = this.sortedChipsPerColor.map(({color,amount,max}) => color);
		this.maxChips = this.sortedChipsPerColor.map(({color,amount,max}) => max);
		this.amountOfColors = this.colors.length;
	}

	useMagic(denominations, buyin) {
		if (denominations.length != this.amountOfColors) {
			return 'Amount of denominations is different from amount of chip colors';
		}
	}

}

function enrich(chipsPerColor, players){
	return chipsPerColor.map((chip) => {
		let enriched = _.cloneDeep(chip);
		enriched.max = _.floor(enriched.amount / players)
		return enriched;
	});
}

class PartialStack extends Stack {
	/*
	 * chip looks like this
	 * { denomination: 10, color: 'yellow', amount: 0}
	*/
	constructor(chips, maxStackSize) {
		super(chips);
		this.maxStackSize = maxStackSize;
		// TODO ensure all amounts are set to 0
		// TODO ensure chips are sorted by denomination highest first
	}

	canAddAnotherChipOfDenomination(denomination){
		//TODO should return true if adding another chip of the given denomination does not exceed maxStackSize
		//TODO should return false if adding another chip DOES exceed maxStackSize
		//TODO should return false if denomination does not exist in the stack
	}

	copy() {
		return _.cloneDeep(this);
	}
}



return {AaronAlg, PartialStack, enrich};

})();