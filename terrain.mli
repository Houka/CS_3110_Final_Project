(*
 * The Terrain Module.
 *   - Gets terrain data from JsonParser and converts it into an easier to work
 *      with interface by storing the data in abstract data structures.
 *)

(* Contains all the stats a terrain has/needs. Info from JSON. *)
type stats = {name:string; atkBonus:int; defBonus:int; img: Sprite.image}
(* Type of the terrain tells which units can travel through it.*)
type terrain = Impassable | Sea of stats | Plain of stats
              | Mountain of stats | City of stats
              | Forest of stats

(* [get_terrain class] returns an arbitrary terrain that of the class [class].
 *  (i.e. get_terrain "grass" will get a grass terrain, whose stats are found in the JSON)
 *
 *  Note: for terrain [class] is mapped to a terrain in the JSON
 *)
val get_terrain : int -> terrain


(*getters*)
val get_atkBonus: terrain -> int
val get_defBonus: terrain -> int
(* [draw t (x,y) w h] draws the terrain's image at (x,y) with width [w] and height [h] *)
val draw : terrain -> (int*int) -> int -> int -> unit