(* Alloted actions that each unit can take *)
type action = Endturn
              | Wait of (int * int)
              | Move of (int * int) * (int * int)
              | Attack of (int * int) * (int * int)

(* 2 Dimensional Array type*)
type 'a matrix = 'a list list

(* The side length of each square in the game grid *)
let gridSide = 50

(* GUI variables *)
let gameWidth = 550
let gameHeight = 400
let gameScale = 1
let gameTitle = "OCaml Fire Emblem"

(* player constants *)
let colorSelected = 0xFF0000
let colorNormal =   0xCCCCCC

