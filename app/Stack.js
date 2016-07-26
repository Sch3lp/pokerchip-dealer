/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {

class Stack {
	constructor(distribution) {
		this.distribution = distribution; //2D array of denominations and their amounts
	}

	get denominations() {
		return this.distribution.map(([d,a]) => d);
	}

	get smallBlindDenomination() {
		return this.denominations[0];
	}

	get bigBlindDenomination() {
		return this.denominations[1];
	}

	get amounts() {
		return this.distribution.map(([d,a]) => a);
	}

	get totalChips() {
		return this.amounts.reduce((prev,cur) => prev + cur);
	}

	get totalValue() {
		return this.distribution.map(([d,a]) => d * a)
								.reduce(((prev, cur) => prev + cur), 0);
	}
}

return Stack;

})();