/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {
	
class Helper {

	static getMultipliers(amountOfDenoms) {
		return {
			2: [10,50],
			3: [5,10,50],
			4: [1,5,25,100],
			5: [1,5,25,50,100],
			6: [1,5,10,25,50,100],
			7: [1,5,10,25,50,100,250]
		}[amountOfDenoms];
	}

	static findIdealDenoms(amountOfDenoms, lowestDenom) {
		let multipliers = Helper.getMultipliers(amountOfDenoms) || [];
		return multipliers.map((multiplier) => lowestDenom * multiplier);
	}
}

return Helper;

})();