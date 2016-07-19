let expect = require('chai').expect;
let PokerSet = require('../app/pokerset');

describe('PokerSet', () => {
	it('distributionPerColor without names returns distribution per color as numbers', () => {
		let set = new PokerSet(75, 75, 100, 100, 50, 50, 25, 25);
		expect(set.distributionPerColor).to.deep.equal([
			[1,75],
			[2,75],
			[3,100],
			[4,100],
			[5,50],
			[6,50],
			[7,25],
			[8,25]]
		);
	});
	it('distributionPerColor with names returns distribution per colors as names', () => {
		let set = new PokerSet(75,75,100,100,50,50,25,25);
		set.setColorNames('white','pink','red','green','blue','black','silver','gold');
		expect(set.distributionPerColor).to.deep.equal([
			['white',75],
			['pink',75],
			['red',100],
			['green',100],
			['blue',50],
			['black',50],
			['silver',25],
			['gold',25]]
		);
	});
	it('distributionPerColor with incomplete names returns distribution per colors with names and numbers', () => {
		let set = new PokerSet(75,75,100,100,50,50,25,25);
		set.setColorNames('white','pink','red','green','blue');
		expect(set.distributionPerColor).to.deep.equal([
			['white',75],
			['pink',75],
			['red',100],
			['green',100],
			['blue',50],
			[6,50],
			[7,25],
			[8,25]]
		);
	});
	it('setting distributionPerColor destructures correctly', () => {
		let set = new PokerSet(9000);
		set.distributionPerColor = [
			['white',75],
			['pink',75],
			['red',100],
			['green',100],
			['blue',50],
			['black',50],
			['silver',25],
			['gold',25]
		];
		expect(set.distributionPerColor).to.deep.equal([
			['white',75],
			['pink',75],
			['red',100],
			['green',100],
			['blue',50],
			['black',50],
			['silver',25],
			['gold',25]]
		);
		set.setColorNames('brown','yellow','white','orange','purple');
		expect(set.distributionPerColor).to.deep.equal([
			['brown',75],
			['yellow',75],
			['white',100],
			['orange',100],
			['purple',50],
			[6,50],
			[7,25],
			[8,25]]
		);
	});
});