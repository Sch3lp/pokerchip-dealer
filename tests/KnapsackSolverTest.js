/* jshint undef: true, unused: false, esnext: true, strict:false, laxbreak:true */
/* globals require, describe, it, console */
let expect = require('chai').expect;
let Stack = require('../app/stack');
let {KnapsackSolver, applyValues, correctBySubtraction, convertToItems, dynamic} = require('../app/knapsacksolver');

describe('KnapsackSolver', function() {
	let _1chips =                [{color:'white',	amount:100,	denomination:0.05}];
	let _2chips = _1chips.concat([{color:'red',		amount:150,	denomination:0.1}]);
	let _3chips = _2chips.concat([{color:'blue',	amount:100,	denomination:0.25}]);
	let _4chips = _3chips.concat([{color:'green',	amount:75,	denomination:0.5}]);
	let _5chips = _4chips.concat([{color:'black',	amount:50,	denomination:1}]);
	let myChips = [
	{color:'orange',		amount: 75,		denomination:0.05},
	{color:'white-red',		amount: 100,	denomination:0.1},
	{color:'red-blue',		amount: 100,	denomination:0.25},
	{color:'blue-white',	amount: 50,		denomination:0.5},
	{color:'green-pink',	amount: 50,		denomination:1},
	{color:'black-salmon',	amount: 25,		denomination:2}
	];

	describe('convertToItems', function() {
		describe('applyValues', function() {
			
			it('with 1 item => value is 1', function() {
				let items = convertToItems(_1chips, 6);
				let itemValues = toColorValuePairs(items);
				expect(itemValues).to.deep.equal([
					{color:'white',	value:1}
				]);
			});
			
			it('with 2 items => values are equal', function() {
				let items = convertToItems(_2chips, 6);
				let itemValues = toColorValuePairs(items);
				expect(itemValues).to.deep.equal([
					{color:'white',	value:1},
					{color:'red',	value:1}
				]);
			});
			
			it('with 3 items => second item has highest value, last item lowest', function() {
				let items = convertToItems(_3chips, 6);
				let itemValues = toColorValuePairs(items);
				expect(itemValues).to.deep.equal([
					{color:'white',	value:2},
					{color:'red',	value:3},
					{color:'blue',	value:1}
				]);
			});
			
			it('with 4 items => second item has highest value, 3rd item second highest, rest descend in values along position in item list', function() {
				let items = convertToItems(_4chips, 6);
				let itemValues = toColorValuePairs(items);
				expect(itemValues).to.deep.equal([
					{color:'white',	value:2},
					{color:'red',	value:4},
					{color:'blue',	value:3},
					{color:'green',	value:1}
				]);
			});
			
			it('with 5 items => same as with 4', function() {
				let items = convertToItems(_5chips, 6);
				let itemValues = toColorValuePairs(items);
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

			it('basically translates denomination to weight', function(){
				let items = convertToItems(_5chips, 6);
				let itemValues = toColorWeightPairs(items);
				expect(itemValues).to.deep.equal([
					{color:'white',	weight:0.05},
					{color:'red',	weight:0.1},
					{color:'blue',	weight:0.25},
					{color:'green',	weight:0.5},
					{color:'black',	weight:1}
				]);
			});
		});
		describe('applyAmounts', function() {

			it('amount of an item is equal to the amount of chips of that color, divided by the amount of players', function(){
				let items = convertToItems(_5chips, 6);
				let itemValues = toColorAmountPairs(items);
				expect(itemValues).to.deep.equal([
					{color:'white',	amount:16},
					{color:'red',	amount:25},
					{color:'blue',	amount:16},
					{color:'green',	amount:12},
					{color:'black',	amount:8}
				]);
			});
		});
	});

	describe('constructor', function() {
		
		it('converts assigned chips to valued and weighted items for use in knapsack', function() {
			let items = new KnapsackSolver(_5chips, 6).items;
			expect(items).to.deep.equal([
		{value:3, weight:0.05,	amount:16,	chip: {color:'white',amount:100,denomination:0.05}},
		{value:5, weight:0.1,	amount:25,	chip: {color:'red',amount:150,denomination:0.1}},
		{value:4, weight:0.25,	amount:16,	chip: {color:'blue',amount:100,denomination:0.25}},
		{value:2, weight:0.5,	amount:12,	chip: {color:'green',amount:75,denomination:0.5}},
		{value:1, weight:1,		amount:8,	chip: {color:'black',amount:50,denomination:1}}
			]);
		});
	});

	describe('correctBySubtraction', function() {
		
		it('exactly one highest denomination overGreedy, removes 1 chip of that denomination', function() {
			let overGreedy = [
		{value:3, chip: {color:'white-red',		amount:15,denomination: 0.05}},
		{value:5, chip: {color:'red-blue',		amount:15,denomination: 0.1}},
		{value:4, chip: {color:'blue-white',	amount:7,denomination: 0.25}},
		{value:2, chip: {color:'green-pink',	amount:8,denomination: 0.5}},
		{value:1, chip: {color:'black-salmon',	amount:3,denomination: 1}}
			];
			let expectedCorrected = [
		{value:3, chip: {color:'white-red',		amount:15,denomination: 0.05}},
		{value:5, chip: {color:'red-blue',		amount:15,denomination: 0.1}},
		{value:4, chip: {color:'blue-white',	amount:7,denomination: 0.25}},
		{value:2, chip: {color:'green-pink',	amount:8,denomination: 0.5}},
		{value:1, chip: {color:'black-salmon',	amount:2,denomination: 1}}
			];
			let stack = overGreedy.map(({v,w,chip})=>chip);
			expect(new Stack(stack).totalValue).to.equal(11);
			let correctedStack = correctBySubtraction(overGreedy,10);
			expect(correctedStack).to.deep.equal(expectedCorrected);
		});
		
		it('exactly one lowest denomination overGreedy, removes 1 chip of that denomination', function() {
			let overGreedy = [
		{value:3, chip: {color:'white-red',		amount:16,denomination: 0.05}},
		{value:5, chip: {color:'red-blue',		amount:15,denomination: 0.1}},
		{value:4, chip: {color:'blue-white',	amount:7,denomination: 0.25}},
		{value:2, chip: {color:'green-pink',	amount:8,denomination: 0.5}},
		{value:1, chip: {color:'black-salmon',	amount:2,denomination: 1}}
			];
			let expectedCorrected = [
		{value:3, chip: {color:'white-red',		amount:15,denomination: 0.05}},
		{value:5, chip: {color:'red-blue',		amount:15,denomination: 0.1}},
		{value:4, chip: {color:'blue-white',	amount:7,denomination: 0.25}},
		{value:2, chip: {color:'green-pink',	amount:8,denomination: 0.5}},
		{value:1, chip: {color:'black-salmon',	amount:2,denomination: 1}}
			];
			let stack = overGreedy.map(({v,w,chip})=>chip);
			expect(new Stack(stack).totalValue).to.equal(10.05);
			let correctedStack = correctBySubtraction(overGreedy,10);
			expect(correctedStack).to.deep.equal(expectedCorrected);
		});
		
		it('exactly two denominations overGreedy, one small blind, one heighest denomination, removes both chips', function() {
			let overGreedy = [
		{value:3, chip: {color:'white-red',		amount:16,denomination: 0.05}},
		{value:5, chip: {color:'red-blue',		amount:15,denomination: 0.1}},
		{value:4, chip: {color:'blue-white',	amount:7,denomination: 0.25}},
		{value:2, chip: {color:'green-pink',	amount:8,denomination: 0.5}},
		{value:1, chip: {color:'black-salmon',	amount:3,denomination: 1}}
			];
			let expectedCorrected = [
		{value:3, chip: {color:'white-red',		amount:15,denomination: 0.05}},
		{value:5, chip: {color:'red-blue',		amount:15,denomination: 0.1}},
		{value:4, chip: {color:'blue-white',	amount:7,denomination: 0.25}},
		{value:2, chip: {color:'green-pink',	amount:8,denomination: 0.5}},
		{value:1, chip: {color:'black-salmon',	amount:2,denomination: 1}}
			];
			let stack = overGreedy.map(({v,w,chip})=>chip);
			expect(new Stack(stack).totalValue).to.equal(11.05);
			let correctedStack = correctBySubtraction(overGreedy,10);
			expect(correctedStack).to.deep.equal(expectedCorrected);
		});
		
		it('more than one denomination overGreedy, removes chips with lowest value first', function() {
			let overGreedy = [
		{value:3, chip: {color:'white-red',		amount:16,denomination: 0.05}},
		{value:5, chip: {color:'red-blue',		amount:16,denomination: 0.1}},
		{value:4, chip: {color:'blue-white',	amount:8,denomination: 0.25}},
		{value:2, chip: {color:'green-pink',	amount:9,denomination: 0.5}},
		{value:1, chip: {color:'black-salmon',	amount:2,denomination: 1}}
			];
			let expectedCorrected = [
		{value:3, chip: {color:'white-red',		amount:15,denomination: 0.05}},
		{value:5, chip: {color:'red-blue',		amount:15,denomination: 0.1}},
		{value:4, chip: {color:'blue-white',	amount:7,denomination: 0.25}},
		{value:2, chip: {color:'green-pink',	amount:8,denomination: 0.5}},
		{value:1, chip: {color:'black-salmon',	amount:2,denomination: 1}}
			];
			let stack = overGreedy.map(({v,w,chip})=>chip);
			expect(new Stack(stack).totalValue).to.equal(10.9);
			let correctedStack = correctBySubtraction(overGreedy,10);
			expect(correctedStack).to.deep.equal(expectedCorrected);
		});
				
		it('biggest possible overGreediness, removes necessary chips', function() {
			let overGreedy = [
		{value:3, chip: {color:'white-red',		amount:16,denomination: 0.05}},
		{value:5, chip: {color:'red-blue',		amount:16,denomination: 0.1}},
		{value:4, chip: {color:'blue-white',	amount:8,denomination: 0.25}},
		{value:2, chip: {color:'green-pink',	amount:9,denomination: 0.5}},
		{value:1, chip: {color:'black-salmon',	amount:3,denomination: 1}}
			];
			let expectedCorrected = [
		{value:3, chip: {color:'white-red',		amount:15,denomination: 0.05}},
		{value:5, chip: {color:'red-blue',		amount:15,denomination: 0.1}},
		{value:4, chip: {color:'blue-white',	amount:7,denomination: 0.25}},
		{value:2, chip: {color:'green-pink',	amount:8,denomination: 0.5}},
		{value:1, chip: {color:'black-salmon',	amount:2,denomination: 1}}
			];
			let stack = overGreedy.map(({v,w,chip})=>chip);
			expect(new Stack(stack).totalValue).to.equal(11.9);
			let correctedStack = correctBySubtraction(overGreedy,10);
			expect(correctedStack).to.deep.equal(expectedCorrected);
		});
	});

	describe.only('solve', function() {
		
		it('pokerbros case', function() {
			let buyin = 10;
			let solver = new KnapsackSolver(myChips, 9);
			let stack = new Stack(solver.solve(buyin));
			assertStackConstraints(stack, myChips, buyin, 9);
			expect(stack.chips).to.deep.equal([
				{color:'orange'			,amount:10	,denomination: 0.05	},// 22.22% -> 22 -> 25
				{color:'white-red'		,amount:15	,denomination: 0.1	},// 33.33% -> 34 -> 35
				{color:'red-blue'		,amount:12	,denomination: 0.25	},// 26.66% -> 27 -> 25
				{color:'blue-white'		,amount:6	,denomination: 0.5	},// 13.33% -> 13 -> 10
				{color:'green-pink'		,amount:2	,denomination: 1	} //  4.44% ->  4 ->  5
			], `\nActual:\n${stack.toString()}\n`);
		});
		
	});

	describe('dynamic', function() {
		
		it('', function() {
			let buyin = 10;
			let items = new KnapsackSolver(myChips, 7).items;
			dynamic(items, 6, buyin)
			let stack = new Stack();
			assertStackConstraints(stack, myChips, buyin, 7);
			expect(stack.chips).to.deep.equal([
				{color:'orange'			,amount:10	,denomination: 0.05	},// 22.22% -> 22 -> 25
				{color:'white-red'		,amount:15	,denomination: 0.1	},// 33.33% -> 34 -> 35
				{color:'red-blue'		,amount:12	,denomination: 0.25	},// 26.66% -> 27 -> 25
				{color:'blue-white'		,amount:6	,denomination: 0.5	},// 13.33% -> 13 -> 10
				{color:'green-pink'		,amount:2	,denomination: 1	} //  4.44% ->  4 ->  5
			], `\nActual:\n${stack.toString()}\n`);
		});
		
	});
});

function toColorValuePairs(items) {
	return items.map((item) => {return {value:item.value, color:item.chip.color};});
}
function toColorWeightPairs(items) {
	return items.map((item) => {return {weight:item.weight, color:item.chip.color};});
}
function toColorAmountPairs(items) {
	return items.map((item) => {return {amount:item.amount, color:item.chip.color};});
}

function assertStackConstraints(actualStack, givenChips, buyin, players) {
	expect(actualStack.totalValue).to.equal(buyin, `Total value of stack (${actualStack.totalValue}) should be equal to the buyin of ${buyin}`);
	actualStack.chips.forEach((chip) => {
		let chipLimit = Math.floor(new Stack(givenChips).amountOf(chip.color) / players);
		expect(chip.amount).to.be.at.most(chipLimit, `Total amount of ${chip.color} (${chip.denomination}): ${chip.amount} can't exceed maximum of ${chipLimit}`);
	});
}