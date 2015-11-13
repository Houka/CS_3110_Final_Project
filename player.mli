open Feunit
open Terrain
(*
 * The Player module
 *   - Takes in keyboard input, FEUnits, and Game State Manager
 *   - Applies change to the Game State
 *   - Controls the player units and draws the cursor
 *)

(* The properties of a player's cursor *)
type cursor = {mutable x: float; mutable y: float; mutable color: string}

(* Draws to the GUI the player's own cursor *)
val draw : unit -> unit

(* Returns a new game state by moving a unit *)
val update : unit -> (feunit list, terrain list)

(* finds player units to move*)
val find_player_units: feunit list -> feunit list


