/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {

class ColorPicker {

	static smartpickColors(denominations, availableColors) {
		if (!denominations || denominations.length == 0 || !availableColors || availableColors.length ==0) {
			return [];
		}
		let [sb, bb, ...rest] = denominations;
		if (availableColors.length == 1) {
			return [{
				color: availableColors[0][0],
				amount: availableColors[0][1],
				denomination: bb
			}];
		}

		let sortedColors = Array.from(availableColors.sort(byMostAvailableColor));
		let mostAvailableColor = sortedColors.shift();
		let nextToMostAvailableColor = sortedColors.shift();
		
		let result = [
			{
				color: nextToMostAvailableColor[0],
				amount: nextToMostAvailableColor[1],
				denomination: sb
			},
			{
				color: mostAvailableColor[0],
				amount: mostAvailableColor[1],
				denomination: bb
			}];

		if (sortedColors && sortedColors.length > 0) {
			// safe assumption that sortedColors and rest are equal in size
			// since denoms were determined based on pokerset
			// and colors come from pokerset as well
			// TODO: refactor this later
			result = result.concat(combine(sortedColors, rest));
		}
		return result;
	}

}

function byMostAvailableColor([prevColor, prevAmount], [curColor, curAmount]) {
	return curAmount > prevAmount 
		? curAmount == prevAmount ? 0 : 1
		: -1;
}

function combine(colors, denoms) {
	return denoms.map((denom, idx) => {
		return {
			color: colors[idx][0],
			amount: colors[idx][1],
			denomination: denom
		};
	});
}

return ColorPicker;

})();