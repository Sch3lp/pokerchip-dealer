#Pokerchip Dealer
To help make a game of Texas Hold'Em more fun, I wanted a tool to help me play short or long games. 

The starting stack-size helps in this way, but it's a PITA to calculate the ideal total amount of chips, and the proper proportions. So that's the problem that this tool is trying to solve.

#Usage
To be able to use this tool, first you'll need [npm](http://npm.org) installed.

Then you can `git clone` this repo.

Then you can run `npm install`.

And finally `npm run pokerchip-dealer`.

##Different approaches
Either you know your small and big blind denominations and want to play with these, no matter what buy-in.

Or you know the buy-in and care about the speed of your game.

Speed is controlled by the amount of big blinds you get for your buy-in.
A high amount of big blinds will lead to a slower paced game and vice versa.
