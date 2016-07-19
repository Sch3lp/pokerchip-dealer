let expect = require('chai').expect;
let Stack = require('../app/stack');

describe('Stack', () => {
	it('denominations returns all the different denominations', () => {
		let stack = new Stack([1,10],[2,20],[3,45]);
		expect(stack.denominations).to.deep.equal([1,2,3]);
	});
	it('amounts returns all the different amounts', () => {
		let stack = new Stack([1,10],[2,20],[3,45]);
		expect(stack.amounts).to.deep.equal([10,20,45]);
	});
	it('totalValue returns the sum of value-amount pairs', () => {
		let stack = new Stack(
			[.25,75], //18.75
			[.50,75], //37.5
			[1,100],  //100
			[5,100],  //500
			[10,50],  //500
			[25,50],  //1250
			[100,25], //2500
			[500,25]  //12500
		);
		expect(stack.totalValue).to.deep.equal(17406.25);
	});
});
