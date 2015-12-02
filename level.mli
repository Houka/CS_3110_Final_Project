open Constants
open Feunit
open Terrain

(*
 * The Level module:
 *   - Stores the state of the game
 *)

(* Store locations and status of each unit and terrain *)
type level = {name: string; unit_matrix: int matrix;
             terrain_matrix: int matrix; next: string}

(* Return the corresponding level based on string input *)
val get_level: string -> level

(* Return the unit matrix, which contains a 2D list of ints where each
 * int represents a unit type. Feunit will indicate what int represents
 * which unit
 *)
val get_unit_matrix: level -> int matrix

(* Return the terrain matrix, which contains a 2D list of ints where each
 * int represents a terrain type. Terrain will indicate what int represents
 * which terrain
 *)
val get_terrain_matrix: level -> int matrix