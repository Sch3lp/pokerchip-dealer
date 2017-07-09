/* jshint undef: true, unused: false, esnext: true, strict:false, laxbreak:true */
/* globals module, require */
module.exports = (() => {

    let _ = require('lodash');
    let BigNumber = require('bignumber.js')

    class DPSolver {
        constructor(evalFunction) {
            this.evalFunction = evalFunction;
        }
        
        solve(assignedChips, buyin, players) {
            new Chips(assignedChips).limitToPlayers(players);
        }
    }

    return { DPSolver };
})();