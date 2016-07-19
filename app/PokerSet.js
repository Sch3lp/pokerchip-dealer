/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {

class PokerSet {
	constructor(...pokerSetDistribution) { //1D array, amounts per named or unnamed color
		this.pokerSetDistribution = pokerSetDistribution;
		this.colorNames = [];
	}

	get distributionPerColor() {
		return this.pokerSetDistribution.map((cur,idx) => {
			let name = this.colorNames[idx] || idx+1;
			return [name, cur];
		});
	}

	set distributionPerColor(amountsPerColor) {
		this.pokerSetDistribution = [];
		this.colorNames = [];
		amountsPerColor.forEach(([colorName, dist]) => {
			if (colorName) {
				this.colorNames.push(colorName);
			}
			if (dist) {
				this.pokerSetDistribution.push(dist);
			}
		});
	}

	setColorNames(...names) {
		this.colorNames = names;
	}

	get totalAmountOfChips() {
		return this.distributionPerColor.reduce((prev,[_,amount]) => prev + amount, 0);
		//because this is cooler than just reducing pokerSetDistribution :)
		//and because it'll prolly come in handy once I'll only be constructing PokerSets with 2D arrays
	}

	validate() {
		if (!this.pokerSetDistribution || this.pokerSetDistribution <= 0) {
			return 'Can\'t do anything with an empty pokerset.';
 		}
 		return '';
	}
}

return PokerSet;
})();