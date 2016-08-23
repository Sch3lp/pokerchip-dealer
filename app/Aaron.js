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

class PartialStack {

	constructor(amountOfChipKinds) {
		let amountOfChipsPerValue = [],
		    canAddChipOfValue = [];
		
		for(let i = 0; i < amountOfChipKinds; i++){
			amountOfChipsPerValue[i] = 0;
			canAddChipOfValue[i] = true;
		}
		this.amountOfChipsPerValue = amountOfChipsPerValue;
		this.canAddChipOfValue = canAddChipOfValue;
	}

	get totalValue() {
		return 0;
		// return this.amountOfChipsPerValue.reduce(());
	}

	mustStopAddingChips() {
		for (let bool of this.canAddChipOfValue){
			if (bool) {
				return false;
			}
		}
		return true;
	}

	addChipToStack(chip) {
		
	}

	copy() {
		return _.cloneDeep(this);
	}
}



return {AaronAlg, PartialStack, enrich};

})();