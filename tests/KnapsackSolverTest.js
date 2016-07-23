let expect = require('chai').expect;
let KnapsackSolver = require('../app/knapsacksolver');

describe('KnapsackSolver', function() {
	let _1chips = [{color:'white',amount:100,denomination:.05}];
	let _2chips = _1chips.concat([{color:'red',amount:150,denomination:.1}]);
	let _3chips = _2chips.concat([{color:'blue',amount:100,denomination:.25}]);
	let _4chips = _3chips.concat([{color:'green',amount:75,denomination:.5}]);
	let _5chips = _4chips.concat([{color:'black',amount:50,denomination:1}]);
	
	describe('applyValues', function() {
		it('with 1 item => value is 1', function() {
			let items = KnapsackSolver.applyValues(_1chips);
			let itemValues = toValueColorPairs(items,_1chips);
			expect(itemValues).to.deep.equal([
				{color:'white',	value:1}
			]);
		});
		it('with 2 items => values are equal', function() {
			let items = KnapsackSolver.applyValues(_2chips);
			let itemValues = toValueColorPairs(items,_2chips);
			expect(itemValues).to.deep.equal([
				{color:'white',	value:1},
				{color:'red',	value:1}
			]);
		});
		it('with 3 items => second item has highest value, last item lowest', function() {
			let items = KnapsackSolver.applyValues(_3chips);
			let itemValues = toValueColorPairs(items,_3chips);
			expect(itemValues).to.deep.equal([
				{color:'white',	value:2},
				{color:'red',	value:3},
				{color:'blue',	value:1}
			]);
		});
		it('with 4 items => second item has highest value, 3rd item second highest, rest descend in values along position in item list', function() {
			let items = KnapsackSolver.applyValues(_4chips);
			let itemValues = toValueColorPairs(items,_4chips);
			expect(itemValues).to.deep.equal([
				{color:'white',	value:2},
				{color:'red',	value:4},
				{color:'blue',	value:3},
				{color:'green',	value:1}
			]);
		});
		it('with 5 items => same as with 4', function() {
			let items = KnapsackSolver.applyValues(_5chips);
			let itemValues = toValueColorPairs(items,_5chips);
			expect(itemValues).to.deep.equal([
				{color:'white',	value:3},
				{color:'red',	value:5},
				{color:'blue',	value:4},
				{color:'green',	value:2},
				{color:'black',	value:1}
			]);
		});
	});

	describe('applyWeights', function() {
		it('2 player, 1 item => weights == total amount of chips', function() {
			let items = KnapsackSolver.applyWeights(_1chips,2);
			let itemWeights = toWeightColorPairs(items);
			expect(itemWeights).to.deep.equal([
				{color:'white', 	weight: 50 }
			]);
		});
		it('1 player => weights == total amount of chips', function() {
			let items = KnapsackSolver.applyWeights(_5chips,1);
			let itemWeights = toWeightColorPairs(items);
			expect(itemWeights).to.deep.equal([
				{color:'white', 	weight: 100 },
				{color:'red',		weight: 150	},
				{color:'blue',		weight: 100	},
				{color:'green',		weight:  75	},
				{color:'black',		weight:  50	}
			]);
		});
		it('3 players => weights == total amount of chips divided by 3', function() {
			let items = KnapsackSolver.applyWeights(_5chips,3);
			let itemWeights = toWeightColorPairs(items);
			expect(itemWeights).to.deep.equal([
				{color:'white', 	weight:  33.33  },
				{color:'red',		weight:  50.00	},
				{color:'blue',		weight:  33.33	},
				{color:'green',		weight:  25.00	},
				{color:'black',		weight:  16.66	}
			]);
		});
		it('6 players => weights == total amount of chips divided by 6', function() {
			let items = KnapsackSolver.applyWeights(_5chips,6);
			let itemWeights = toWeightColorPairs(items);
			expect(itemWeights).to.deep.equal([
				{color:'white', 	weight: 16.66   },
				{color:'red',		weight: 25	    },
				{color:'blue',		weight: 16.66	},
				{color:'green',		weight: 12.5	},
				{color:'black',		weight:  8.33	}
			]);
		});
		it('10 players => weights == total amount of chips divided by 10', function() {
			let items = KnapsackSolver.applyWeights(_5chips,10);
			let itemWeights = toWeightColorPairs(items);
			expect(itemWeights).to.deep.equal([
				{color:'white', 	weight: 10  },
				{color:'red',		weight: 15  },
				{color:'blue',		weight: 10	},
				{color:'green',		weight:  7.5},
				{color:'black',		weight:  5	}
			]);
		});
	});
});

function toValueColorPairs(values, chips){
	return values.map((value, idx) => {return {color:chips[idx].color,value};});
}

function toWeightColorPairs(items){
	return items.map(({weight,wrapped:{color}}) => {return {color,weight};});
}