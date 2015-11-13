open Feunit
open Terrian
open Level
open Yojson.Basic.Util
(*
 * The Json Parser module
 *   - Sets the initial state of the game from a json file.
 *)

(* Returns the matrix of unit locations *)
val getUnitMatrix : unit -> int list list

(* Returns the matrix of terrain locations *)
val getTerrainMatrix : unit -> int list list

(* Getter funtions that parses the json file into their repective forms and
 *  returns a list of all the items
  *)
val getAllUnitData : unit -> feunit list
val getAllTerrainData : unit -> terrain list
val getAllLevelData : unit -> level list
