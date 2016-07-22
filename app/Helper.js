/* jshint undef: true, unused: false, esnext: true, strict:false */
/* globals module */
module.exports = (() => {
	
class Helper {

	static getMultipliers(amountOfDenoms) {
		if (!amountOfDenoms) return [];
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

	static findIdealProportions(assignedChips) {
		let colors = assignedChips.length;
		switch(colors){
			case 1: return [1];
			case 2: return [.5,.5];
			case 3: return [.5,.65,.15];
			case 4: return [.24,.36,.26,.14];
			case 5: return [.22,.34,.26,.14,.04];
			case 6: return [.22,.34,.26,.14,.04,.02];
			case 7: return [.22,.34,.26,.14,.04,.02,.02];
			case 8: return [.22,.34,.26,.14,.04,.02,.02,.02];
		}
	}
}

return Helper;

})();