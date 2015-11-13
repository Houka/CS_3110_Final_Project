open Feunit
open Terrian
open Level
open Yojson.Basic.Util
(*
 * The Json Parser module
 *   - Sets the initial state of the game from a json file.
 *)

(* Returns the matrix of unit locations *)
val get_unit_matrix : unit -> int list list

(* Returns the matrix of terrain locations *)
val get_terrain_matrix : unit -> int list list

(* Getter funtions that parses the json file into their repective forms and
 *  returns a list of all the items
  *)
val get_all_unit_data : unit -> feunit list
val get_all_terrain_data : unit -> terrain list
val get_all_level_data : unit -> level list
