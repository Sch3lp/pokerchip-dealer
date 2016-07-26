# Captains Log
## Day 9
Some derping around with `Array.from()` copying objects by reference where I expected them to be copied by value.

(Re-)Discovered `lodash`'s `_.deepCopy()`.

## Day 8
My idea that weight == amount of chips divided by players is incorrect.

The reason is that it's not the weight of the entire stack that's constraining, but it's the weight of one chip stack (a stack of chips of 1 color). And this is indeed equal to the amount of chips divided by players.

The thing that's constraining the total stack is the buyin. So if anything, it's the denomination that equals weight.

## Day 7
Had to revisit the applyWeights function. It didn't make sense that the chip colors I had the most amounts of had the biggest weight. It should be the other way around.

## Day 6
Conversion of assigned chips to knapsack items is done.

Still unsure how to encapsulate _private_ methods `applyValues` and `applyWeights`, but still be able to separately test them.

Current solution is to separately export them, so at least you'd have to explicitly import them.

Also still unsure if I'll require the original chip object literals, which is why I haven't extracted those into a `AssignedChip` class yet.

## Day 5
Today I ventured into _Money Conversion Problems_ land.

After I tried to figure out what the ideal proportions of a stack would be based on the number of different colors, I started thinking that there had to be algorithms out there that already have proven solutions to this problem.

A couple of wikipedia links later, if anything, it confirms the hunch I had that these are not particularly easy problems to solve. Luckily there's a lot of documentation about it:

[Knapsack problem](https://en.wikipedia.org/wiki/Knapsack_problem)

[Change-making problem](https://en.wikipedia.org/wiki/Change-making_problem)

[Coin problem](https://en.wikipedia.org/wiki/Coin_problem)

Guess I'll have to do some reading first. :)

I also discovered [Money.js](http://openexchangerates.github.io/money.js/). Maybe this library can help me in some way as well. :pray:

---

Money.js can't help me.

I think I figured out that the problem I'm trying to solve is in fact the [Bounded Knapsack problem](https://en.wikipedia.org/wiki/Knapsack_problem#Definition).

The “knapsack” is the ideal Stack.

The items I want to put in are the chips. 

The item value is based on the "ideal proportion". For example an ideal proportion with 4 chip colors might look like 24/36/26/14.

The item weight (constraint) is based on the total amount of chips per color in the pokerset, each divided by the amount of players.

The extra constraint is that the total value of chips in the stack can't exceed the buy-in. I hope using the knapsack solution and then rearranging a little bit to adhere to the last constraint will be achievable (and comprehensible in code).

## Day 4
Big blind should have biggest _weight_ ~= proportion of stack

        10 * 0.05 = 0.5   0.22222
        15 * 0.10 = 1.5   0.33333
        12 * 0.25 = 3     0.26666
         6 * 0.5  = 3     0.13333
         2 * 1    = 2     0.04444

I feel like I've been productive in creating the `ColorPicker`. I also was a little bit proud of a silly [refactoring](https://github.com/Sch3lp/pokerchip-dealer/commit/90f6e3a8834ae1beeb29fab45f2d467fa3364767#diff-e7d239fcae0a96404762d00f1c47562c) I did, it's way shorter to read now, yet still comprehensible enough.

But where my code was "more logical" before (first add small blind, then big blind, then the rest), and also readable (by extension), now it's more concise but you have to figure out why I first switch around the position of small and big blind denominations and re-order on ascending denominations after the `combine` happened. I don't think it's that hard to understand. Especially since it's concise enough.

That's why I prefer the code the way it is now and why I felt proud afterwards.

## Day 3
Since there seem to be so many "rules" that can all have an impact, 
but that you might **not** want to apply in a hardcore fashion all the time.

It got me thinking of maybe representing all different aspects of a pokergame

_i.e. chips, their denominations, their value, their actual value, the buy-in, the amount of players, ..._

as rules (within a ruleset maybe).

So that you can enforce or "impose" (softer) these rules.

So maybe I start over, yes?

Like, keep the classes but assemble them out of rules.

## Day 2
Struggling with which problem to solve.

Because there are so many approaches.

For every problem scenario there's usually a couple of knowns and one to many unknowns.

Either you know your small and big blind denominations and want to play with these, no matter what buy-in.

Or, you know the buy-in and care about the speed of your game.

Speed is controlled by the amount of big blinds you get for your buy-in.
A high amount of big blinds will lead to a slower paced game and vice versa.

Or, you know the buy-in and what your ideal small and big blind denominations are, but you don't know which chips out of your pokerset are best to use.

I did some reading and learned that **in tournaments** you need to provide your players with a stack that is good for 50 big blinds in return for their buy-in.

## Day 1
Set out to code a program that helps me make nice Stacks for when we host poker nights.

I recently bought a new pokerset (a bigger one), which has way more different kinds of chips than the one I previously had. And it feels wasteful not to use them all in our game.