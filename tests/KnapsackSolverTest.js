let expect = require('chai').expect;
let KnapsackSolver = require('../app/knapsacksolver');

describe('KnapsackSolver', function() {
	describe('applyValues', function() {
		it('with 1 item => value is 1', function() {
			let assignedChips = [
				{color:'white',amount:100,denomination:.05}
			];
			let items = KnapsackSolver.applyValues(assignedChips);
			let itemValues = toValueColorPairs(items);
			expect(itemValues).to.deep.equal([
				{color:'white',	value:1}
			]);
		});
		it('with 2 items => values are equal', function() {
			let assignedChips = [
				{color:'white',amount:100,denomination:.05},
				{color:'red',amount:150,denomination:.1}
			];
			let items = KnapsackSolver.applyValues(assignedChips);
			let itemValues = toValueColorPairs(items);
			expect(itemValues).to.deep.equal([
				{color:'white',	value:1},
				{color:'red',	value:1}
			]);
		});
		it('with 3 items => second item has highest value, last item lowest', function() {
			let assignedChips = [
				{color:'white',amount:100,denomination:.05},
				{color:'red',amount:150,denomination:.1},
				{color:'blue',amount:100,denomination:.25}
			];
			let items = KnapsackSolver.applyValues(assignedChips);
			let itemValues = toValueColorPairs(items);
			expect(itemValues).to.deep.equal([
				{color:'white',	value:2},
				{color:'red',	value:3},
				{color:'blue',	value:1}
			]);
		});
		it('with 4 items => second item has highest value, 3rd item second highest, rest descend in values along position in item list', function() {
			let assignedChips = [
				{color:'white',amount:100,denomination:.05},
				{color:'red',amount:150,denomination:.1},
				{color:'blue',amount:100,denomination:.25},
				{color:'green',amount:100,denomination:.5}
			];
			let items = KnapsackSolver.applyValues(assignedChips);
			let itemValues = toValueColorPairs(items);
			expect(itemValues).to.deep.equal([
				{color:'white',	value:2},
				{color:'red',	value:4},
				{color:'blue',	value:3},
				{color:'green',	value:1}
			]);
		});
		it('with 5 items => same as with 4', function() {
			let assignedChips = [
				{color:'white',amount:100,denomination:.05},
				{color:'red',amount:150,denomination:.1},
				{color:'blue',amount:100,denomination:.25},
				{color:'green',amount:75,denomination:.5},
				{color:'black',amount:50,denomination:1}
			];
			let items = KnapsackSolver.applyValues(assignedChips);
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
});

function toValueColorPairs(items){
	return items.map(({value,wrapped:{color}}) => {return {color,value};});
}