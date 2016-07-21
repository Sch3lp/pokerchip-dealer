let expect = require('chai').expect;
let ColorPicker = require('../app/colorpicker');

describe.only('ColorPicker', () => {
	describe('smartpickColors' ,() => {
		let fiveDenoms = [.05,.1,.25,.5,1];
		let white100 = [['white',100]];
		it('with no denoms => empty array', () => {
			let stack = ColorPicker.smartpickColors(undefined, white100);
			expect(stack).to.deep.equal([]);
			stack = ColorPicker.smartpickColors([], white100);
			expect(stack).to.deep.equal([]);
		});
		it('with no available colors => empty array', () => {
			let stack = ColorPicker.smartpickColors(fiveDenoms,undefined);
			expect(stack).to.deep.equal([]);
			stack = ColorPicker.smartpickColors([.05,.1,.25,.5,1],[]);
			expect(stack).to.deep.equal([]);
		});
		it('with 1 available color => only big blinds', () => {
			let stack = ColorPicker.smartpickColors(fiveDenoms, white100);
			expect(stack).to.deep.equal([
				{ color: 'white', 
				  amount: 100,
				  denomination: .10
				}]);
		});
	});
});
