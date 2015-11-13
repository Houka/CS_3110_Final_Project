(*
 * The Json Parser module
 *   - Sets the initial state of the game from a json file.
 *)
open Yojson.Basic.Util

type unit = {attack: int; defense: int; move: int; max_hp: int;
                mutable current_hp: int; weapon: string; image:string}
type terrain = {atk_bonus:int; def_bonus: int; image: string}

(* Returns the matrix of unit locations *)
val get_unit_locs : Yojson.Basic.json -> unit list list

(* Returns the matrix of terrain locations *)
val get_terrain_locs : Yojson.Basic.json -> terrain list list

(* Returns the number of allies given the unit location list*)
val num_allies : unit list list -> int

(* Returns the number of enemies given the unit location list*)
val num_enemies : unit list list -> int


