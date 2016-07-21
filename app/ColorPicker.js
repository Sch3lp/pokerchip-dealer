/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {

class ColorPicker {

	static smartpickColors(denominations, availableColors) {
		if (!denominations || denominations.length == 0 || !availableColors || availableColors.length ==0) {
			return [];
		}
		let [sb, bb, ...rest] = denominations;
		if (availableColors.length == 1){
			return [{
				color: availableColors[0][0],
				amount: availableColors[0][1],
				denomination: bb
			}];
		}
		// return [{ color: 'white', amount: 15, denomination: 0.05 }];
	}

}

return ColorPicker;

})();