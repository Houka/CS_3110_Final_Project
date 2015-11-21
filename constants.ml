open Feunit

(* Alloted actions that each Player can take *)
type action = Wait of feunit | Move of feunit * int * int | Attack of feunit * feunit

(* The side length of each square in the game grid *)
let gridSide = 50;