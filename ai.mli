open Feunit
open Terrain
(*
 * The AI module
 *   - Sets commands for the units
 *   - Updates the units based on algorithms
 *        - Rush Nearest
 *        - Swarm Lowest Health
 *        - Focus On Easiest Unit To Take Down
 *)

(* Returns a new game state by moving a unit *)
val update : unit -> unit list list -> terrain list list ->
                (unit list list, terrain list list)

(* finds enemy units to move*)
val find_enemy_units: unit list list -> unit list