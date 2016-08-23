function findBestPack() {
	var maxPackValues = [[0]]; // maximum pack value found so far
	var bestCombos = [[0]]; // best combination found so far
	var opts = [0]; // item index for 0 of item 0 
	var encodedItems = [1]; // item encoding for 0 of item 0
	var choose = 0;
	for (var j = 0; j<data.length; j++) {
		opts[j+1] = opts[j]+data[j].pieces; // item index for 0 of item j+1
		encodedItems[j+1] = encodedItems[j] * (1+data[j].pieces); // item encoding for 0 of item j+1
	}
	for (var j = 0; j<opts[data.length]; j++) {
		maxPackValues[0][j+1] = bestCombos[0][j+1] = 0; // best values and combos for empty pack: nothing
	}
	for (var weight=1; weight<=400; weight++) {
		maxPackValues[weight] = [0];
		bestCombos[weight] = [0];
		for (var j=0; j<data.length; j++) {
			var availablePieces = data[j].pieces; // how many of these can we have?
			var base = opts[j]; // what is the item index for 0 of these?
			for (var selectedPieces = 1; selectedPieces<=availablePieces; selectedPieces++) {
				var selectedWeight = selectedPieces * data[j].weight; // how much do these items weigh?
				var isCarryable = weight >= selectedWeight ? 1 :0; // can we carry this many?
				var worth = isCarryable * selectedPieces * data[j].value; // how much are they worth?
				var itemNumberOfSelected = base + selectedPieces; // what is the item number for this many?
				var availableWeight = weight - isCarryable * selectedWeight; // how much other stuff can we be carrying?
				var encodedCombo = selectedPieces * encodedItems[j] + bestCombos[availableWeight][base]; // encoded combination
				let previousBestValue = maxPackValues[weight][itemNumberOfSelected-1];
				let bestValue = worth + maxPackValues[availableWeight][base];
				let currentBestValue = maxPackValues[weight][itemNumberOfSelected];
				currentBestValue = Math.max(previousBestValue, bestValue); // best value
				let previousBestCombo = bestCombos[weight][itemNumberOfSelected-1];
				let bestCombo = currentBestValue > previousBestValue ? encodedCombo : previousBestCombo;
				choose = bestCombos[weight][itemNumberOfSelected] = bestCombo;
			}
		}
	}
	var best = [];
	for (var j = data.length-1; j>=0; j--) {
		best[j] = Math.floor(choose/encodedItems[j]);
		choose- = best[j]*encodedItems[j];
	}
	var out='<table><tr><td><b>Count</b></td><td><b>Item</b></td><th>unit weight</th><th>unit value</th>';
	var wgt = 0;
	var val = 0;
	for (var i = 0; i<best.length; i++) {
		if (0==best[i]) continue;
		out+='</tr><tr><td>'+best[i]+'</td><td>'+data[i].name+'</td><td>'+data[i].weight+'</td><td>'+data[i].value+'</td>'
		wgt+= best[i]*data[i].weight;
		val+= best[i]*data[i].value;
	}
	out+ = '</tr></table><br/>Total weight: '+wgt;
	out+ = '<br/>Total value: '+val;
	document.body.innerHTML = out;
}