open Feunit
open Terrain

(*
 * The GameStateManager Module.
 *   - Keeps track of the current Game State (i.e. whether the GUI and player
 *      are viewing and interacting with the menu, level 1, etc...)
 *   - Handles updating the AI and Player logic by giving them data from
 *      the current map and its elements
 *   - Takes in filtered data from the JSON and uses it to initialize
 *      the current Game State (i.e. a level is created, drawn, and updated)
 *   - Basically oversees who/what gets to update and who gets to draw
 *   - Keeps track of turn
 *)

(* setter for the current level of the game
*)
val set_level_data : string -> unit

(* The main update loop for this class.
 *  This will handle all the management logic and delegate when something needs
 *  to be updated. Mainly called by main.ml which passes it the keypresses
 *)
val update : unit -> unit

(* The main drawing function.
 *  This will handle all the delegation of who can draw onto the screen and
 *  when they can draw. Handles who draws to which layer in the screen.
 *)
val draw : unit -> unit

