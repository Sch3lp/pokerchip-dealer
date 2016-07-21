/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {

class ColorPicker {

	static smartpickColors(denominations, availableColors) {
		if (!denominations || denominations.length == 0 || !availableColors || availableColors.length ==0) {
			return [];
		}
		let [sb, bb, ...rest] = denominations;
		// console.log(`sb: ${sb}`);
		// console.log(`bb: ${bb}`);
		// console.log(`rest: ${rest}`);
		if (availableColors.length == 1) {
			return [{
				color: availableColors[0][0],
				amount: availableColors[0][1],
				denomination: bb
			}];
		}
		let mostAvailableColor = availableColors
			.reduce(this.mostAvailableColorFunc,['',0]);
		let nextToMostAvailableColor = availableColors
			.filter(([color,amount]) => color != mostAvailableColor[0])
			.reduce(this.mostAvailableColorFunc,['',0]);
		
		return [
			{
				color: nextToMostAvailableColor[0],
				amount: nextToMostAvailableColor[1],
				denomination: sb
			},
			{
				color: mostAvailableColor[0],
				amount: mostAvailableColor[1],
				denomination: bb
			}
		];
		// return [{ color: 'white', amount: 15, denomination: 0.05 }];
	}

	static mostAvailableColorFunc([prevColor, prevAmount], [curColor, curAmount]) {
		return curAmount > prevAmount 
			? [curColor, curAmount] 
			: [prevColor, prevAmount];
	}

}

return ColorPicker;

})();