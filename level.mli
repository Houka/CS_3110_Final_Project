open Feunit
open Terrain
(*
 * The Level module
 *   - Stores the state of the game
 *)

(*stores locations and status of each unit and terrain*)
type level = {name: string; unit_matrix: int list list;
              terrain_matrix: int list list; next: string}

(*returns the corresponding level based on string input*)
val get_level: string -> level

(* returns the unit matrix, which contains a 2d list of ints where each
 *  int represents a unit type. Feunit will have the what int represents
 *  which unit
 *)
val get_unit_matrix: level -> int list list

(* returns the terrain matrix, which contains a 2d list of ints where each
 *  int represents a terrain type. Terrain will have the what int represents
 *  which terrain
 *)
val get_terrain_matrix: level -> int list list