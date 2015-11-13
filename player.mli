open Feunit
open Terrain
(*
 * The Player module
 *   - Takes in keyboard input, FEUnits, and Game State Manager
 *   - Applies change to the Game State
 *   - Controls the player units and draws the cursor
 *)

(* Returns a new game state by moving a unit *)
val update : unit -> unit list list -> terrain list list ->
                (unit list list, terrain list list)

(* finds player units to move*)
val find_player_units: unit list list -> unit list


