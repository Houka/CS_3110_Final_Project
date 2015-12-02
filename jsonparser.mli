open Constants
open Yojson.Basic.Util
(*
 * The Json Parser module:
 *   - Sets the initial state of the game from a json file.
 *   - Contains getter funtions that parse the json file into their repective
 *     forms and returns a list of all the items. (ex: get_all_unit_data returns
 *     an assoc list matching unit data to class number)
 *)

type terrain_info = {name: string; atkBonus: int; defBonus: int;
                    terrain_type: string; img: string}
type feunit_info = {name: string; maxHp: int; atk: int; def: int;
                    movRange: int; atkRange: int; weapon: string; img: string }
type level_info = {name: string; unit_matrix: int matrix;
                  terrain_matrix: int matrix; next: string}

(* Return association list matching class to stats for feunit *)
val get_all_unit_data : unit -> (int*feunit_info) list

(* Return association list matching class to stats for terrain *)
val get_all_terrain_data : unit -> (int*terrain_info) list

(* Return association list matching class to stats for level *)
val get_all_level_data : unit -> (string*level_info) list

(* Return all the images used by the json file *)
val get_images : unit -> string list
