open Feunit
open Terrain
open Constants
(*
 * The Player module
 *   - Takes in keyboard input, FEUnits, and Game State Manager
 *   - Applies change to the Game State
 *   - Controls the player units and draws the cursor
 *)

(* The properties of a player's cursor *)
type cursor = {x: int; y: int; img: Sprite.image}

(* Draws to the GUI the player's own cursor *)
val draw : unit -> unit

(* Returns a new game state by moving a unit *)
val update : feunit matrix -> terrain matrix -> action list

(* gets the cursor *)
val get_cursor : unit -> cursor

