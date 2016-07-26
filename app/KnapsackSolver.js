/* jshint undef: true, unused: false, esnext: true, strict:false, laxbreak:true */
/* globals module, require */
module.exports = (() => {

let _ = require('lodash');
	
/* 
 * See LOG.md#Day5
 * See also https://en.wikipedia.org/wiki/Knapsack_problem#Definition
 */
class KnapsackSolver {

	constructor(assignedChips, players){
		this.players = players;
		this.items = convertToItems(assignedChips, players);
	}

	solve(buyin) {
		let copiedItems = _.cloneDeep(this.items);

		// TODO check if sum of all amounts, divided by players, is already lower than the buyin
		// TODO minimum of 1 in each denomination?
		let result = greedy(copiedItems, this.players, buyin);
		
		let greedyStackWorth = result.reduce((prev, {color,amount,denomination}) => prev + (amount*denomination), 0);
		if (greedyStackWorth > buyin) { //apply correction

		}
		return result;
	}
}

function greedy(copiedItems, players, buyin) {
	let stackWorth = 0;
	let sortedItems = copiedItems.sort(byValueDesc);

	for (let item of sortedItems) {
		let maxChipCount = _.floor(item.chip.amount / players);
		let currentChipCount = 0;
		while (item.chip.amount > 0 && currentChipCount < maxChipCount && stackWorth < buyin) {
			currentChipCount++;
			item.chip.amount--;
			stackWorth += item.chip.denomination;
		}
		item.chip.amount = currentChipCount;
	}
	let result = copiedItems
		.map(({value,weight,chip}) => chip)
		.sort(byDenomAsc);
	return result;
}

function convertToItems(assignedChips, players) {
	let values = applyValues(assignedChips);
	let weights = applyWeights(assignedChips, players);
	return assignedChips.map((chip, idx) => {
		return {
			value: values[idx],
			weight: weights[idx],
			chip: chip
		};
	});
}

function applyValues(assignedChips) {
	if (assignedChips.length == 1) return [1];
	if (assignedChips.length == 2) return [1,1];
	if (assignedChips.length == 3) return [2,3,1];
	// if (assignedChips.length == 5) return [4,5,3,2,1];
	let copy = _.cloneDeep(assignedChips);
	let sb = copy.shift();
	let bb = copy.shift();
	let bbplus1 = copy.shift();
	copy.unshift(bb,bbplus1,sb);
	return copy
	.reverse()
	.map((el, idx) => {
		return {
			value: idx+1,
			denomination: el.denomination
		};
	})//retain denom so I can retain idx position by sorting (fragile I know)
	.sort(byDenomAsc)
	.map(({value}) => value);//just retain value
}

function applyWeights(items, players) {
	let totalAmount = items.reduce((prev,{amount}) => prev + amount, 0);
	return items.map((el) => totalAmount - _.floor(el.amount / players, 2));
}

function byDenomAsc(one, two){ return one.denomination - two.denomination; }
function byValueDesc(one, two) { return two.value - one.value;}
function byValueAmountRatioDesc(one, two) {
	let ratio1 = one.value / one.chip.amount;
	let ratio2 = two.value / two.chip.amount;
	return ratio2 - ratio1;
}

return {KnapsackSolver, applyValues, applyWeights};

})();