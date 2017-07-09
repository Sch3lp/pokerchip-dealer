# Gegeven:
int n = aantal verschillende soorten chips

String kleuren[0..n-1] = kleuren van de beschikbare chips

int maxChips[0..n-1] = maximum aantal chips per kleur, overeenkomstig met kleuren[0..n-1], gesorteerd van hoog naar laag

int[] waarde[0..n-1] = gegeven waarden (>0) van de chips, nog niet gekoppeld aan een kleur (bvb. in eurocent)

int gevraagdeWaarde = waarde die de uiteindelijke stack zal waard zijn (bvb. in eurocent)

double evaluatie(PartialStack) = functie die de fitness van een partiële stack bepaalt ahv een partiële stack.
Ter vereenvoudiging is deze monotoon stijgend in alle dimensies
(m.a.w. het toevoegen van een chip aan de partiële stack leidt altijd tot een evaluatiewaarde die groter dan of gelijk aan de oorspronkelijke evaluatiewaarde is).
Het algoritme kan echter eenvoudig worden aangepast om functies die niet monotoon stijgend zijn aan te kunnen.

# Gebruikte datastructuren:
PartialStack: een voorstelling van een partiële stack. Deze bestaat uit:

aantalChipsPerWaarde[0..n-1] waarbij aantalChipsPerWaarde[i] het aantal chips van waarde waarde[i] voorstelt (Ook hier, nog niet gekoppeld aan een kleur).

magChipVanWaardeToevoegen[0..n-1] waarbij magChipVanWaardeToevoegen[i] een booleaanse waarde is die voorstelt of het nog mogelijk is
om een chip van waarde waarde[i] toe te voegen om een nieuwe partiële stack te bekomen. Zie sectie 'constraints' en 'algoritme' voor verdere uitleg.

totaleWaarde

boolean magGeenChipsMeerToevoegen() returns true wanneer alle elementen van magGeenChipsMeerToevoegen false zijn, en false wanneer er nog minstens 1 true is.

PartialStackQueue: een queue die de partialStacks behandelt. Nieuwe partialStacks worden achteraan toegevoegd en vooraan gebeurt de behandeling (First In First Out).

Bij de constructie van een nieuwe partialStack is elk element van aantalChipsPerWaarde gelijk aan 0, en elk element van magChipVanWaardeToevoegen 'true'.

# Constraints voor partialStacks p (A = voor alle, E = er bestaat):

p.totaleWaarde <= gevraagdeWaarde

for all i in [0..n-1]: sortedDescending(aantalChipsPerWaarde)[i] <= maxChips[i].

Aangezien de maxima gesorteerd van hoog naar laag zijn, zorgt dit er voor de partiële stack een bijectie (1 op 1, geen kleur 2x gebruikt) bestaat tussen
kleuren en aantalChipsPerWaarde waarbij het mogelijk is om met de beschikbare fysieke chips de stack te bouwen.

De functie die evalueert of een PartialStack voldoet aan de constraints is 'boolean satisfiesConstraints()'.

# Algoritme
```
PartialStackQueue queue = []
List<PartialStack> volledigeStacks = []
queue.add(new PartialStack())
while(!queue.isEmpty()) {
    PartialStack stack = queue.pop()
    for(int i = 0; i < n; i++){
        if(stack.magChipVanWaardeToevoegen[i]){
            PartialStack uitgebreideStack = stack.copy()
            for(int j = 0; j < i; j++){
                // Dit om ervoor te zorgen dat dimensies in volgorde worden uitgebreid.
                // Eens er in dimensie i wordt uitgebreid, mag er niet meer naar in een lagere dimensie worden uitgebreid.
                // Dit om een uniek pad naar elke mogelijke partialStack.aantalChipsPerWaarde te garanderen.
                // Vb. [2,2,3] wordt bereikt door [0,0,0] -> [1,0,0]-> [2,0,0] -> [2,1,0] -> [2,2,0] -> [2,2,1] -> [2,2,2] -> [2,2,3]
                uitgebreideStack.magChipVanWaardeToevoegen[i] = false
            }
            uitgebreideStack.addChipToStack(i)
            if(uitgebreideStack.satisfiesConstraints()){

                queue.add(uitgebreideStack)
            } else {
                stack.magChipVanWaardeToevoegen[i] = false
            }
        }
    }
    if(stack.magGeenChipsMeerToevoegen() && stack.totaleWaarde == gevraagdeWaarde){
        volledigeStacks.add(stack)
    }
}
bestStack = volledigeStacks[argmax_i(evaluatie(volledigeStacks[i]))]
```

evaluatie() is een functie die de waarde van een VolledigeStack berekent.

argmax_() is een functie die de hoogste waarde neemt en de index van de VolledigeStack terug geeft.