let expect = require('chai').expect;
let PokerSet = require('../app/pokerset');

describe('PokerSet', () => {
	it('distributionPerColor without names returns distribution per color as numbers', () => {
		let pokerSet = new PokerSet(75, 75, 100, 100, 50, 50, 25, 25);
		expect(pokerSet.distributionPerColor).to.deep.equal([
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
		let pokerSet = new PokerSet(75,75,100,100,50,50,25,25);
		pokerSet.setColorNames('white','pink','red','green','blue','black','silver','gold');
		expect(pokerSet.distributionPerColor).to.deep.equal([
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
		let pokerSet = new PokerSet(75,75,100,100,50,50,25,25);
		pokerSet.setColorNames('white','pink','red','green','blue');
		expect(pokerSet.distributionPerColor).to.deep.equal([
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
		let pokerSet = new PokerSet(9001);
		pokerSet.distributionPerColor = [
			['white',75],
			['pink',75],
			['red',100],
			['green',100],
			['blue',50],
			['black',50],
			['silver',25],
			['gold',25]
		];
		expect(pokerSet.distributionPerColor).to.deep.equal([
			['white',75],
			['pink',75],
			['red',100],
			['green',100],
			['blue',50],
			['black',50],
			['silver',25],
			['gold',25]]
		);
		pokerSet.setColorNames('brown','yellow','white','orange','purple');
		expect(pokerSet.distributionPerColor).to.deep.equal([
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

describe('totalAmountOfChips', () => {
	it('1 type 666 chips => 666', () => {
		let pokerSet = new PokerSet(666);
		expect(pokerSet.totalAmountOfChips).to.equal(666);
	});
	it('3 types with chips => total of those types', () => {
		let pokerSet = new PokerSet(111,222,333);
		expect(pokerSet.totalAmountOfChips).to.equal(666);
	});
	it('0 types, 0 chips => 0', () => {
		let pokerSet = new PokerSet();
		expect(pokerSet.totalAmountOfChips).to.equal(0);
	});
	it('1 type, 0 chips => 0', () => {
		let pokerSet = new PokerSet();
		pokerSet.distributionPerColor = [['white']];
		expect(pokerSet.totalAmountOfChips).to.equal(0);
	});
});

describe('validate', () => {
	it('Empty PokerSet is unusable', () => {
		let pokerSet = new PokerSet();
		expect(pokerSet.validate()).to.equal('Can\'t do anything with an empty pokerset.');
	});
	it('PokerSet with just types but no amounts is also unusable', () => {
		let pokerSet = new PokerSet();
		pokerSet.distributionPerColor = [['white'],['black']];
		expect(pokerSet.validate()).to.equal('Can\'t do anything with an empty pokerset.');
	});
	it('PokerSet with 1 denomination is fine', () => {
		let set = new PokerSet(20);
		expect(set.validate()).to.equal('');
	});
	it('PokerSet with 2 denominations with same amount is fine', () => {
		let set = new PokerSet(20,20);
		expect(set.validate()).to.equal('');
	});
});
