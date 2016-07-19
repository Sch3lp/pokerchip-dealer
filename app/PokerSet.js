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
			this.colorNames.push(colorName);
			this.pokerSetDistribution.push(dist);
		});
	}

	setColorNames(...names) {
		this.colorNames = names;
	}
}

return PokerSet;
})();