(*
 * The Terrain Module.
 *   - Gets terrain data from JsonParser and converts it into an easier to work
 *      with interface by storing the data in abstract data structures.
 *)

(* Contains all the stats a terrain has/needs. Info from JSON. *)
type stats = {name:string; atkBonus:int; defBonus:int; img: Images.t;
              x: int; y: int}
(* Type of the terrain tells which units can travel through it.*)
type terrain = Null | Sea of stats | Plain of stats
              | Mountain of stats | City of stats
              | Forest of stats

(* [getTerrain class name (x,y)] returns an arbitrary terrain that is of the name [name]
 *  and the class [class]. Also sets the terrain pos ([x],[y])
 *  (i.e. getUnit "archer" will get an archer, whose stats are found in the JSON)
 *
 *  Note: for terrain [class] is mapped to Null, Sea, Plain, Mountain, etc...
 *)
val get_terrain : int -> string -> (int*int) -> terrain

(* [moveTerrain name x y] returns back the updated terrain where its x and y
 * values to [x] and [y] respectively.
*)
val move_terrain : terrain -> (int*int) -> terrain