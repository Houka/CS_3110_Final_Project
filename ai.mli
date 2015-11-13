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
val update : unit -> (feunit list, terrain list)

(* finds enemy units to move*)
val find_enemy_units: feunit list -> feunit list