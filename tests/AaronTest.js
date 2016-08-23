/* jshint undef: true, unused: false, esnext: true, strict:false, laxbreak:true */
/* globals require, describe, it, console */
let expect = require('chai').expect;
let _ = require('lodash');
let {AaronAlg, PartialStack, enrich} = require('../app/aaron');

describe('PartialStack', function() {
	describe('mustStopAddingChips', function() {
		it('should return false for a new PartialStack', function() {
			let partialStack = new PartialStack(5);
			expect(partialStack.mustStopAddingChips()).to.be.false;
		});
		it('should return false when at least one chip of any kind can be added', function() {
			let partialStack = new PartialStack(3);
			partialStack.canAddChipOfValue[0] = false;
			partialStack.canAddChipOfValue[1] = false;
			partialStack.canAddChipOfValue[2] = true;
			expect(partialStack.mustStopAddingChips()).to.be.false;
		});
		it('should return true when at no chip of any kind can be added', function() {
			let partialStack = new PartialStack(3);
			partialStack.canAddChipOfValue[0] = false;
			partialStack.canAddChipOfValue[1] = false;
			partialStack.canAddChipOfValue[2] = false;
			expect(partialStack.mustStopAddingChips()).to.be.true;
		});
	});

	describe('copy', function() {
		it('should return a deep copy of the given PartialStack', function() {
			let partialStack = new PartialStack(4);
			partialStack.canAddChipOfValue[0] = false;
			partialStack.canAddChipOfValue[1] = true;
			partialStack.canAddChipOfValue[2] = false;
			let copy = partialStack.copy();
			expect(copy).not.to.equal(partialStack);
			expect(copy).to.deep.equal(partialStack);
		});
	});
});

describe.only('AaronAlg', function() {
	let _1chips =                [{color:'white',	amount:100}];
	let _2chips = _1chips.concat([{color:'red',		amount:150}]);
	let _3chips = _2chips.concat([{color:'blue',	amount:100}]);
	let _4chips = _3chips.concat([{color:'green',	amount:75}]);
	let _5chips = _4chips.concat([{color:'black',	amount:50}]);
	let myChips = [
	{color:'orange',		amount: 75},
	{color:'white-red',		amount: 100},
	{color:'red-blue',		amount: 100},
	{color:'blue-white',	amount: 50},
	{color:'green-pink',	amount: 50}
	];

	describe('enrich', function() {
		it('should enrich the chips with maximum number of chips to distribute', function() {
			let enrichedChips = enrich(_4chips,2);
			expect(enrichedChips).to.deep.equal([
				{color:'white',	amount:100,	max:50},
				{color:'red',	amount:150,	max:75},
				{color:'blue',	amount:100,	max:50},
				{color:'green',	amount:75,	max:37}
				]);
		});
	});

	describe('constructor', function() {
		it('should enrich the chips with maximum number of chips to distribute', function() {
			let aaron = new AaronAlg(_4chips, 2);
			expect(aaron.sortedChipsPerColor).to.deep.equal([
				{color:'red',	amount:150,	max:75},
				{color:'white',	amount:100,	max:50},
				{color:'blue',	amount:100,	max:50},
				{color:'green',	amount:75,	max:37}
				]);
		});
		it('should sort amounts and maxChips on highest to lowest maxChip value', function() {
			let aaron = new AaronAlg(_4chips, 2);
			expect(aaron.maxChips).to.deep.equal([75,50,50,37]);
			expect(aaron.colors).to.deep.equal(['red','white','blue','green']);
			expect(aaron.amountOfColors).to.be.equal(4);
		});
	});

	describe('useMagic', function() {
		it('should stop processing when amount of denoms does not equal amount of colors', function() {
			let aaron = new AaronAlg(_5chips, 6);
			let result = aaron.useMagic([5,10,20], 100);
			expect(result).to.equal('Amount of denominations is different from amount of chip colors');
		});
	});
});
























