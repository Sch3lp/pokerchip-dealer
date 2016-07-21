/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {

class ColorPicker {

	static smartpickColors(denominations, availableColors) {
		if (!denominations || denominations.length == 0 || !availableColors || availableColors.length ==0) {
			return [];
		}
		let denoms = Array.from(denominations);
		let sb = denoms.shift();
		let bb = denoms.shift();
		denoms.unshift(bb, sb);
		let sortedColors = Array.from(availableColors.sort(byMostAvailableColorDesc));
		
		// safe assumption that sortedColors and rest are equal in size
		// since denoms were determined based on pokerset
		// and colors come from pokerset as well
		// on the other hand, colors is most constraining anyways
		// TODO: refactor this later
		return combine(sortedColors, denoms).sort(byDenominationAsc);
	}
}

function byMostAvailableColorDesc([prevColor, prevAmount], [curColor, curAmount]) {
	return curAmount > prevAmount 
		? curAmount == prevAmount ? 0 : 1
		: -1;
}

function combine(colors, denoms) {
	return colors.map(([color, amount], idx) => {
		return {
			color: color,
			amount: amount,
			denomination: denoms[idx]
		};
	});
}

function byDenominationAsc(stack1, stack2) {
	return stack1.denomination - stack2.denomination;
}

return ColorPicker;

})();