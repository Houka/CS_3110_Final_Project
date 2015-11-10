open Sprite

(*
 * The Terrain Module.
 *   - Gets terrain data from JsonParser and converts it into an easier to work
 *      with interface by storing the data in abstract data structures.
 *)

(* Contains all the stats a terrain has/needs. Info from JSON. *)
type stats = {name:string; atkBonus:int; defBonus:int; img: image;
              x: int; y: int}
(* Type of the terrain tells which units can travel through it.*)
type terrain = Null | Sea of init_stats | Plain of init_stats
              | Mountain of init_stats | City of init_stats
              | Forest of init_stats


(* [getTerrain name (x,y)] returns an arbitrary terrain that is of the name [name]
 *  Also sets the terrain pos ([x],[y])
 *  (i.e. getUnit "archer" will get an archer, whose stats are found in the JSON)
 *)
val getTerrain : string -> (int*int) -> terrain