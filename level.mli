open Feunit
open Terrain
(*
 * The Level module
 *   - Stores the state of the game
 *)

(*stores locations and status of each unit and terrain*)
type level = {name: string; unitMatix: feunit list list;
              terrainMatrix: terrain list list}

(*returns the corresponding level based on string input*)
val get_level: string -> level