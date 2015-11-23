(* Alloted actions that each Player can take *)
type action = Wait of (int * int)
              | Move of (int * int) * (int * int)
              | Attack of (int * int) * (int * int)

(* 2 Dimensional Array type*)
type 'a matrix = 'a list list
(* The side length of each square in the game grid *)
let gridSide = 50;

