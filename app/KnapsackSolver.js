/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {
	
/* 
 * See LOG.md#Day5
 * See also https://en.wikipedia.org/wiki/Knapsack_problem#Definition
 */
class KnapsackSolver {

	static applyValues(assignedChips) {
		if (assignedChips.length == 1) {
			return [ {value: 1, wrapped: assignedChips[0]} ];
		}
		if (assignedChips.length == 2) {
			return [ {value: 1, wrapped: assignedChips[0]}, {value: 1, wrapped: assignedChips[1]}];
		}
		if (assignedChips.length == 3) {
			return [ {value: 2, wrapped: assignedChips[0]}, {value: 3, wrapped: assignedChips[1]}, {value: 1, wrapped: assignedChips[2]}];
		}
		let copy = Array.from(assignedChips);
		let sb = copy.shift();
		let bb = copy.shift();
		let bbplus1 = copy.shift();
		copy.unshift(bb,bbplus1,sb);
		return copy.reverse().map((el, idx) => {
			return {
				value: idx+1,
				wrapped: el
			};
		}).sort(byDenominationAsc);
	}

	static applyWeights(items, players) {
		return items.map((el) => {
			return {
				weight: floor(el.amount / players, 2),
				wrapped: el
			};
		});
	}
}

function byDenominationAsc(values1, values2) {
	return values1.wrapped.denomination - values2.wrapped.denomination;
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