let expect = require('chai').expect;
let Helper = require('../app/helper');

describe('Helper.findIdealDenoms', () => {
	it('non existing amount, returns empty array', () => {
		expect(Helper.findIdealDenoms(164, 1)).to.deep.equal([]);
	});
	it('lowest denom is 0, return empty array', () => {
		expect(Helper.findIdealDenoms(1, 0)).to.deep.equal([]);
	});
	it('4 denoms, lowest is 1 => 1;5;25;100', () => {
		expect(Helper.findIdealDenoms(4, 1)).to.deep.equal([1,5,25,100]);
	});
});