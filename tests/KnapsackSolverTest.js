let expect = require('chai').expect;
let {KnapsackSolver, applyWeights, applyValues} = require('../app/knapsacksolver');

describe.only('KnapsackSolver', function() {
	let _1chips =                [{color:'white',amount:100,denomination:.05}];
	let _2chips = _1chips.concat([{color:'red',amount:150,denomination:.1}]);
	let _3chips = _2chips.concat([{color:'blue',amount:100,denomination:.25}]);
	let _4chips = _3chips.concat([{color:'green',amount:75,denomination:.5}]);
	let _5chips = _4chips.concat([{color:'black',amount:50,denomination:1}]);
	
	describe('applyWeights', function() {
		it('with 1 item => weight is 1', function() {
			let items = applyWeights(_1chips);
			let itemWeights = toWeightColorPairs(items,_1chips);
			expect(itemWeights).to.deep.equal([
				{color:'white',	weight:1}
			]);
		});
		it('with 2 items => weights are equal', function() {
			let items = applyWeights(_2chips);
			let itemWeights = toWeightColorPairs(items,_2chips);
			expect(itemWeights).to.deep.equal([
				{color:'white',	weight:1},
				{color:'red',	weight:1}
			]);
		});
		it('with 3 items => second item has highest weight, last item lowest', function() {
			let items = applyWeights(_3chips);
			let itemWeights = toWeightColorPairs(items,_3chips);
			expect(itemWeights).to.deep.equal([
				{color:'white',	weight:2},
				{color:'red',	weight:3},
				{color:'blue',	weight:1}
			]);
		});
		it('with 4 items => second item has highest weight, 3rd item second highest, rest descend in values along position in item list', function() {
			let items = applyWeights(_4chips);
			let itemWeights = toWeightColorPairs(items,_4chips);
			expect(itemWeights).to.deep.equal([
				{color:'white',	weight:2},
				{color:'red',	weight:4},
				{color:'blue',	weight:3},
				{color:'green',	weight:1}
			]);
		});
		it('with 5 items => same as with 4', function() {
			let items = applyWeights(_5chips);
			let itemWeights = toWeightColorPairs(items,_5chips);
			expect(itemWeights).to.deep.equal([
				{color:'white',	weight:3},
				{color:'red',	weight:5},
				{color:'blue',	weight:4},
				{color:'green',	weight:2},
				{color:'black',	weight:1}
			]);
		});
	});

	describe('applyValues', function() {
		it('2 player, 1 item => values == total amount of chips', function() {
			let values = applyValues(_1chips,2);
			let itemValues = toValueColorPairs(values,_1chips);
			expect(itemValues).to.deep.equal([
				{color:'white', 	value: 50 }
			]);
		});
		it('1 player => values == total amount of chips', function() {
			let values = applyValues(_5chips,1);
			let itemValues = toValueColorPairs(values,_5chips);
			expect(itemValues).to.deep.equal([
				{color:'white', 	value: 100 },
				{color:'red',		value: 150	},
				{color:'blue',		value: 100	},
				{color:'green',		value:  75	},
				{color:'black',		value:  50	}
			]);
		});
		it('3 players => values == total amount of chips divided by 3', function() {
			let values = applyValues(_5chips,3);
			let itemValues = toValueColorPairs(values,_5chips);
			expect(itemValues).to.deep.equal([
				{color:'white', 	value:  33.33  },
				{color:'red',		value:  50.00	},
				{color:'blue',		value:  33.33	},
				{color:'green',		value:  25.00	},
				{color:'black',		value:  16.66	}
			]);
		});
		it('6 players => values == total amount of chips divided by 6', function() {
			let values = applyValues(_5chips,6);
			let itemValues = toValueColorPairs(values,_5chips);
			expect(itemValues).to.deep.equal([
				{color:'white', 	value: 16.66   },
				{color:'red',		value: 25	    },
				{color:'blue',		value: 16.66	},
				{color:'green',		value: 12.5	},
				{color:'black',		value:  8.33	}
			]);
		});
		it('10 players => values == total amount of chips divided by 10', function() {
			let values = applyValues(_5chips,10);
			let itemValues = toValueColorPairs(values,_5chips);
			expect(itemValues).to.deep.equal([
				{color:'white', 	value: 10  },
				{color:'red',		value: 15  },
				{color:'blue',		value: 10	},
				{color:'green',		value:  7.5},
				{color:'black',		value:  5	}
			]);
		});
	});

	describe('constructor', function() {
		it('converts assigned chips to valued and weighted items for use in knapsack', function() {
			let items = new KnapsackSolver(_5chips, 6).items;
			expect(items).to.deep.equal([
		{value: 16.66,	weight:3,	chip: {color:'white',amount:100,denomination:.05}},
		{value: 25, 	weight:5,	chip: {color:'red',amount:150,denomination:.1}},
		{value: 16.66,	weight:4,	chip: {color:'blue',amount:100,denomination:.25}},
		{value: 12.5,	weight:2,	chip: {color:'green',amount:75,denomination:.5}},
		{value:  8.33,	weight:1,	chip: {color:'black',amount:50,denomination:1}}
			]);
		});
	});
});

function toWeightColorPairs(weights, chips){
	return weights.map((weight, idx) => {return {color:chips[idx].color,weight};});
}

function toValueColorPairs(values, chips){
	return values.map((value, idx) => {return {color:chips[idx].color,value};});
}