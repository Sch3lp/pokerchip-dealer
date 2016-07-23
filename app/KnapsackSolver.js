/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {
	
/* 
 * See LOG.md#Day5
 * See also https://en.wikipedia.org/wiki/Knapsack_problem#Definition
 */
class KnapsackSolver {

	static applyValues(assignedChips) {
		if (assignedChips.length == 1) return [1];
		if (assignedChips.length == 2) return [1,1];
		if (assignedChips.length == 3) return [2, 3, 1];
		let copy = Array.from(assignedChips);
		let sb = copy.shift();
		let bb = copy.shift();
		let bbplus1 = copy.shift();
		copy.unshift(bb,bbplus1,sb);
		return copy
		.reverse()
		.map((el, idx) => {
			return {
				value: idx+1,
				denomination: el.denomination
			};
		})//retain denom so I can retain idx position by sorting (fragile I know)
		.sort(byDenominationAsc)
		.map(({value}) => value);//just retain value
	}

	static applyWeights(items, players) {
		return items.map((el) => floor(el.amount / players, 2));
	}
}

function byDenominationAsc(values1, values2) {
	return values1.denomination - values2.denomination;
}

/*
 * Thanks MDN ♥︎
 * https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/round#Example:_Decimal_rounding
 */
function floor(number, precision) {
    var factor = Math.pow(10, precision);
    var tempNumber = number * factor;
    var roundedTempNumber = Math.floor(tempNumber);
    return roundedTempNumber / factor;
};

return KnapsackSolver;

})();