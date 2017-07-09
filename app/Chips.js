/* jshint undef: true, unused: false, esnext: true, strict:false, laxbreak:true */
/* globals module, require */
module.exports = (() => {

    let _ = require('lodash');
    let BigNumber = require('bignumber.js')

    class Chip {
        constructor(color, denom) {
            this.color = color;
            this.denom = denom;
        }
    }
    
    class ChipStack {
        constructor(chip, amount) {
            this.color = chip.color;
            this.denom = chip.denom;
            this.amount = amount;
        }
    }
    
    class Chips {
        constructor(...chipStacks) {
            this.chipStacks = chipStacks;
        }

        limitToPlayers(players) {
            let copiedChipStacks = _.cloneDeep(this.chipStacks);
            copiedChipStacks.forEach((chipStack) => chipStack.amount /= players);
            return copiedChipStacks;
        }
    }

    return { Chips, Chip };
})();