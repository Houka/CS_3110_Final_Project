# CS 3110 Final Project
## OCaml Fire Emblem
- Install dependencies: `opam install camlimages`
- To compile: `cs3110 compile -p camlimages.all,pa_ounit,graphics,yojson,async -t main`
- To run: `cs3110 run main game.json`

## Dependencies:
- Graphics
- Yojson
- Async
- Camlimages.all
- Pa_ounit

## Members:
- Changxu Lu
- Alex Xu
- Leo Tang
- Annie Cheng

## Summary:
Our goal is to replicate the battle system in Fire Emblem for the GameBoy Advance. We will be creating a system where a player will fight against an A.I. controlled opponent in a turn-based strategy game. This will not be an exact copy of the original game but will contain the core mechanics that define Fire Emblem.

## Controls:
- WASD to move cursor
- J to select
- K to deselect
- Q to quit

## Gameplay:
- You can control blue units. Your goal is to eliminate all red (enemy) units.
- This is a turn based game.
- Every time it is your turn each of your units may move only once. You can choose to not move your unit.
- Units may also attack or wait. Upon attacking or waiting the unit's turn is over.
- When attacking another unit it will counterattack if you are within its range, unless it dies from your attack.
- When all of your units' turns are over the enemy's turn will begin.
- To end your turn before all your units have waited or attacked, select "End turn" by clicking "J" anywhere and selecting end turn.
- Hover over a unit to see its stats in the upper left hand corner.
- Hover over a terrain spot to see the stat bonuses in the lower right hand corner.
- Keep the command prompt open to see whose turn it is and view other information on the state of the game. It will also tell you if you attempt to perform an illegal move (in which case nothing happens).

## Hints:
- Level 2:
  Use the weapon triangle to your advantage. Swords beat axes, lances beat swords, axes beat lances.
  Your archers can attack other short-ranged units without fear of counterattack, so use them to soften up your enemy before killing them.
- Level 3:
  Occupy the cities for a huge terrain advantage.
  Your archers can attack other short-ranged units without fear of counterattack, so use them to soften up your enemy before killing them.

## Known bugs/issues:



