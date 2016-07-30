/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {

class Stack {
	constructor(chips) {
		this.chips = chips.sort(byDenomAsc); //array of chips with color, amount and denomination
	}

	get denominations() {
		return this.chips.map(({c,a,denomination}) => denomination);
	}

	get smallBlind() {
		return this.chips[0];
	}

	get bigBlind() {
		return this.chips[1];
	}

	get amounts() {
		return this.chips.map(({c,amount,d}) => amount);
	}

	get totalChips() {
		return this.amounts.reduce((prev,cur) => prev + cur);
	}

	get totalValue() {
		return this.chips.reduce((prev, {c,amount,denomination}) => prev + denomination * amount, 0);
	}

	toString() {
		return this.chips.map(({color, amount, denomination}) => {
			return `${color} chips (${denomination}):  ${amount}`;
		}).join('\n');
	}
}

function byDenomAsc(one, two){ return one.denomination - two.denomination; }

return Stack;

})();