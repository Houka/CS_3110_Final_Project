open Feunit
open Terrain
(*
 * The Player module
 *   - Takes in keyboard input, FEUnits, and Game State Manager
 *   - Applies change to the Game State
 *   - Controls the player units and draws the cursor
 *)

(* The properties of a player's cursor *)
type cursor = {x: int; y: int; color: int}

(* Draws to the GUI the player's own cursor *)
val draw : unit -> unit

(* Returns a new game state by moving a unit *)
val update : (bool*char) -> feunit array -> terrain array -> unit

(* gets the cursor *)
val get_cursor : unit -> cursor

