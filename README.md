# CS 3110 Final Project
## OCaml Fire Emblem
- Install dependencies: `opam install camlimages`
- To compile: `cs3110 compile -p camlimages.all,pa_ounit,graphics,yojson,async -t main`
- To run: `cs3110 run main example.json`

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
- Q to quit

## Gameplay:
- You can control blue units. Your goal is to eliminate all red (enemy) units.
- This is a turn based game.
- Hover over a unit to see its stats.
- Hover over a terrain spot to see the stat bonuses.
