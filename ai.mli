open Feunit
open Terrain
open Constants
(*
 * The AI module:
 *   - Returns a set of commands for the units
 *   - Updates the units based on the following algorithms
 *        - Rush Nearest
 *        - Swarm Lowest Health
 *        - Focus On Easiest Unit To Take Down
 *)

(* Return a new game state by moving a unit *)
val update : feunit list list -> terrain list list -> action list