open Feunit

(* Alloted actions that each Player can take *)
type action = Wait of feunit * (int * int)
              | Move of feunit * (int * int) * (int * int)
              | Attack of feunit * (int * int) * feunit * (int * int)

(* 2 Dimensional Array type*)
type 'a matrix = 'a list list
(* The side length of each square in the game grid *)
let gridSide = 50;

