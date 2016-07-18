/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {
	
class Helper {

	static getMultipliers(amountOfDenoms) {
		return {
			2: [1,2],
			3: [1,2,5],
			4: [1,2,5,10],
			5: [1,2,5,10,20],
			6: [1,2,5,10,20,50],
			7: [1,2,5,10,20,50,100]
		}[amountOfDenoms];
	}

	static findIdealDenominations(amountOfDenoms, lowestDenom) {
		let multipliers = Helper.getMultipliers(amountOfDenoms) || [];
		return multipliers.map((multiplier) => lowestDenom * multiplier);
	}
}

return Helper;

})();