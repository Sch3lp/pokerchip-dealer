/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {
let _ = require('lodash');

class ColorPicker {

	static smartpickColors(denominations, availableColors) {
		if (!denominations || denominations.length == 0 || !availableColors || availableColors.length ==0) {
			return [];
		}
		let denoms = _.cloneDeep(denominations);
		let sb = denoms.shift();
		let bb = denoms.shift();
		denoms.unshift(bb, sb);
		let sortedColors = _.cloneDeep(availableColors.sort(byMostAvailableColorDesc));
		
		// So far for safe assumptions (WHERE IS MY PAIR?!)
		// Since we limit the denoms to 5, it's possible that denoms < colors.
		// QuickFix: deal with both cases
		// TODO: refactor this later, or limit to 5 denoms after returning
		return combine(sortedColors, denoms).sort(byDenominationAsc);
	}
}

function byMostAvailableColorDesc([prevColor, prevAmount], [curColor, curAmount]) {
	return curAmount > prevAmount 
		? curAmount == prevAmount ? 0 : 1
		: -1;
}

function combine(colors, denoms) {
	if (colors.length <= denoms.length){
		return colors.map(([color, amount], idx) => {
			return {
				color: color,
				amount: amount,
				denomination: denoms[idx]
			};
		});
	} else {
		return denoms.map((denom, idx) => {
			return {
				color: colors[idx][0],
				amount: colors[idx][1],
				denomination: denom
			};
		});
	}
}

function byDenominationAsc(assignedChips1, assignedChips2) {
	return assignedChips1.denomination - assignedChips2.denomination;
}

return ColorPicker;

})();