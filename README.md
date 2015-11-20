# CS 3110 Final Project
## OCaml Fire Emblem
- Install dependencies: `opam install camlimages`
- To compile: `cs3110 compile -p camlimages.all,pa_ounit,graphics,yojson,async -t main`
- To run: `cs3110 run main`

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

## Key System Features:
- Graphics & Animation
- Grid-Based Control Scheme
- Rock-Paper-Scissor Battle Mechanics
- Artificial Intelligence for Opponent Player
- Data-Driven Game Design
- Keyboard-Controlled User Interface

##Narrative Description:
The System will be split into Graphics, User Interface, JSON Parsing, Artificial Intelligence, and Core Game Mechanics. For Graphics, the main functionalities would be to make sure that we can draw image files onto a window, manipulate those images, and update the screen at 60 fps. For User Interface, the system will mostly deal with getting keyboard input and supplying other modules with this information. JSON Parsing will deal with the creation of a schema that defines the terrain contents of each level, the stats of each element in the terrain, and the design content for the game. Artificial Intelligence will mostly focus on the different strategies that can be implemented against a human player. Three strategies to consider are Rush Nearest, Swarm Lowest Health, and Focus On Easiest FEUnit To Take Down. The Core game mechanics will set up the properties of each element involved in the game. It should handle how each element interacts and provide the skeleton objects for which the JSON parser will use to create the levels.