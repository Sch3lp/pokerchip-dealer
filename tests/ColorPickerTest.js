let expect = require('chai').expect;
let ColorPicker = require('../app/colorpicker');

describe.only('ColorPicker', function() {
	describe('smartpickColors', function() {
		let fiveDenoms = [.05,.1,.25,.5,1];
		let white100 = [['white',100]];
		let red100white75 = [['red',100],['white',75]];
		it('with no denoms => empty array', function() {
			let stack = ColorPicker.smartpickColors(undefined, white100);
			expect(stack).to.deep.equal([]);
			stack = ColorPicker.smartpickColors([], white100);
			expect(stack).to.deep.equal([]);
		});
		it('with no available colors => empty array', function() {
			let stack = ColorPicker.smartpickColors(fiveDenoms,undefined);
			expect(stack).to.deep.equal([]);
			stack = ColorPicker.smartpickColors([.05,.1,.25,.5,1],[]);
			expect(stack).to.deep.equal([]);
		});
		it('with 1 available color => only big blinds', function() {
			let stack = ColorPicker.smartpickColors(fiveDenoms, white100);
			expect(stack).to.deep.equal([
				{ color: 'white', 
				  amount: 100,
				  denomination: .10
				}]);
		});
		it('with 2 available colors, 1 more than the other => big blind is assigned to most available color', function() {
			let stack = ColorPicker.smartpickColors(fiveDenoms, red100white75);
			expect(stack).to.deep.equal([
				{ color: 'white', 
				  amount: 75,
				  denomination: .05
				},
				{ color: 'red', 
				  amount: 100,
				  denomination: .10
				}]);
		});
		it('with 5 available colors => big blind is assigned to most available color', function() {
			let colors = [['white',75],['red',100],['black',25],['blue',50],['green',200]];
			let stack = ColorPicker.smartpickColors(fiveDenoms, colors);
			expect(stack).to.deep.equal([
				{ color: 'red', 
				  amount: 100,
				  denomination: .05
				},
				{ color: 'green', 
				  amount: 200,
				  denomination: .10
				},
				{ color: 'white', 
				  amount: 75,
				  denomination: .25
				},
				{ color: 'blue', 
				  amount: 50,
				  denomination: .5
				},
				{ color: 'black', 
				  amount: 25,
				  denomination: 1
				}
				]);
		});
	});
});
