let expect = require('chai').expect;
let Helper = require('../app/helper');

describe('getMultipliers()', () => {
	it('Multiplier 1', () =>{
		expect(Helper.getMultipliers(1)).to.deep.equal([1]);
	});
	it('Multiplier 2', () =>{
		expect(Helper.getMultipliers(2)).to.deep.equal([1,2]);
	});
	it('Multiplier 3', () =>{
		expect(Helper.getMultipliers(3)).to.deep.equal([1,2,5]);
	});
	it('Multiplier 4', () =>{
		expect(Helper.getMultipliers(4)).to.deep.equal([1,2,5,10]);
	});
	it('Multiplier 5', () =>{
		expect(Helper.getMultipliers(5)).to.deep.equal([1,2,5,10,20]);
	});
	it('Multiplier 6', () =>{
		expect(Helper.getMultipliers(6)).to.deep.equal([1,2,5,10,20,50]);
	});
	it('Multiplier 7', () =>{
		expect(Helper.getMultipliers(7)).to.deep.equal([1,2,5,10,20,50,100]);
	});
	it('Multiplier 8', () =>{
		expect(Helper.getMultipliers(8)).to.deep.equal([1,2,5,10,20,50,100,200]);
	});
});
	
describe('findIdealDenominations()', () => {
	it('lowest denomination is 0, return empty array', () => {
		expect(Helper.findIdealDenominations(1, 0)).to.deep.equal([]);
	});
	it('4 denominations, lowest is 1', () => {
		expect(Helper.findIdealDenominations(4, 1)).to.deep.equal([1,2,5,10]);
	});
	it('4 denominations, lowest is 2', () => {
		expect(Helper.findIdealDenominations(4, 2)).to.deep.equal([2,4,10,20]);
	});
	it('7 denominations, lowest is 3', () => {
		expect(Helper.findIdealDenominations(7, 3)).to.deep.equal([3, 6, 15, 30, 60, 150, 300]);
	});
	it('5 denominations, lowest is .05', () => {
		expect(Helper.findIdealDenominations(5, .05)).to.deep.equal([.05, .10, .25, .50, 1]);
	});
});