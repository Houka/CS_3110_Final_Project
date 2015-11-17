open Feunit
open Terrain
open Level
open Yojson.Basic.Util
(*
 * The Json Parser module
 *   - Sets the initial state of the game from a json file.
 *)

(* Getter funtions that parses the json file into their repective forms and
 *  returns a list of all the items.
 * (ex: get_all_unit_data returns a feunit list that has all the units the game will use)
  *)

type terrain_info
type feunit_info

(*returns association list matching class to stats for feunit*)
val get_all_unit_data : unit -> (int*feunit_info) list

(*returns association list matching class to stats for terrain*)
val get_all_terrain_data : unit -> (int*terrain_info) list
val get_all_level_data : unit -> level list
