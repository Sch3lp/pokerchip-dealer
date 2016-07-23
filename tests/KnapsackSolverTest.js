let expect = require('chai').expect;
let KnapsackSolver = require('../app/knapsacksolver');

describe('KnapsackSolver', function() {
	let _1chips = [{color:'white',amount:100,denomination:.05}];
	let _2chips = _1chips.concat([{color:'red',amount:150,denomination:.1}]);
	let _3chips = _2chips.concat([{color:'blue',amount:100,denomination:.25}]);
	let _4chips = _3chips.concat([{color:'green',amount:100,denomination:.5}]);
	let _5chips = _4chips.concat([{color:'black',amount:50,denomination:1}]);
	
	describe('applyValues', function() {
		it('with 1 item => value is 1', function() {
			let items = KnapsackSolver.applyValues(_1chips);
			let itemValues = toValueColorPairs(items);
			expect(itemValues).to.deep.equal([
				{color:'white',	value:1}
			]);
		});
		it('with 2 items => values are equal', function() {
			let items = KnapsackSolver.applyValues(_2chips);
			let itemValues = toValueColorPairs(items);
			expect(itemValues).to.deep.equal([
				{color:'white',	value:1},
				{color:'red',	value:1}
			]);
		});
		it('with 3 items => second item has highest value, last item lowest', function() {
			let items = KnapsackSolver.applyValues(_3chips);
			let itemValues = toValueColorPairs(items);
			expect(itemValues).to.deep.equal([
				{color:'white',	value:2},
				{color:'red',	value:3},
				{color:'blue',	value:1}
			]);
		});
		it('with 4 items => second item has highest value, 3rd item second highest, rest descend in values along position in item list', function() {
			let items = KnapsackSolver.applyValues(_4chips);
			let itemValues = toValueColorPairs(items);
			expect(itemValues).to.deep.equal([
				{color:'white',	value:2},
				{color:'red',	value:4},
				{color:'blue',	value:3},
				{color:'green',	value:1}
			]);
		});
		it('with 5 items => same as with 4', function() {
			let items = KnapsackSolver.applyValues(_5chips);
			let itemValues = toValueColorPairs(items);
			expect(itemValues).to.deep.equal([
				{color:'white',	value:3},
				{color:'red',	value:5},
				{color:'blue',	value:4},
				{color:'green',	value:2},
				{color:'black',	value:1}
			]);
		});
	});

	describe.only('applyWeights', function() {
		it('1 player => weights == total amount of chips', function() {

		});
	});
});

function toValueColorPairs(items){
	return items.map(({value,wrapped:{color}}) => {return {color,value};});
}

function toWeightColorPairs(items){
	return items.map(({weight,wrapped:{color}}) => {return {color,weight};});
}