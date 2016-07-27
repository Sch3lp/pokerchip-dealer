let expect = require('chai').expect;
let Stack = require('../app/stack');

describe.only('Stack', function() {
	let chips  =               [{color:'blue-white',	amount:12,	denomination: 0.25}];
	let chips2 = chips.concat( [{color:'white-red',		amount:10,	denomination: 0.05}]);
	let chips3 = chips2.concat([{color:'black-salmon',	amount:2,	denomination: 1}]);
	let chips4 = chips3.concat([{color:'red-blue',		amount:15,	denomination: 0.1}]);
	let chips5 = chips4.concat([{color:'green-pink',	amount:6,	denomination: 0.5}]);

	it('denominations returns all the different denominations, sorted ascending', function() {
		let stack = new Stack(chips5);
		expect(stack.denominations).to.deep.equal([0.05,0.1,0.25,0.5,1]);
	});

	it('smallBlind returns the smallest denomination', function() {
		let stack = new Stack(chips5);
		expect(stack.smallBlind).to.deep.equal({color:'white-red', amount:10, denomination: 0.05});
	});

	it('bigBlind returns the second smallest denomination', function() {
		let stack = new Stack(chips5);
		expect(stack.bigBlind).to.deep.equal({color:'red-blue', amount:15, denomination: 0.1});
	});

	it('amounts returns all the different amounts', function() {
		let stack = new Stack(chips5);
		expect(stack.amounts).to.deep.equal([10,15,12,6,2]);
	});

	it('totalValue returns the value of the stack', function() {
		let stack = new Stack(chips5);
		expect(stack.totalValue).to.deep.equal(10);
	});
});
