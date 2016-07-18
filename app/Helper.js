/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {
	
class Helper {

	static getMultipliers(amountOfDenoms) {
		let result = [1];
		for (let n = 1; n < amountOfDenoms; n++) {
			result.push( ( Math.pow((n % 3),2) + 1 ) * ( Math.pow(10,Math.floor(n/3)) ) );
		}
		return result;
	}

	static findIdealDenominations(amountOfDenoms, lowestDenom) {
		if (!amountOfDenoms || !lowestDenom) return [];
		let multipliers = Helper.getMultipliers(amountOfDenoms) || [];
		return multipliers.map((multiplier) => lowestDenom * multiplier);
	}
}

return Helper;

})();