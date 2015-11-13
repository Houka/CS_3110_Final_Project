open Feunit
open Terrain
(*
 * The Level module
 *   - Stores the state of the game
 *)

(*stores locations and status of each unit and terrain*)
type level = {unitMatrix: feunit list list; terrainMatrix: terrain list list}
type level = {name: string; unitMatix: feunit list list;
              terrainMatrix: terrain list list}
>>>>>>> 4c3da7df05d8e18fdfa0881e6094956364776057

(*returns the corresponding level based on string input*)
val get_level: string -> level
