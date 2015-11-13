(*
 * The Level module
 *   - Stores the state of the game
 *)

open Yojson.Basic.Util
open Feunit
open Terrain


(*stores locations and status of each unit and terrain*)
type level = {unit_locs: feunit list list; terrain_locs: terrain list list}

(*returns the corresponding level based on string input*)
val get_level: string -> level