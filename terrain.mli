(*
 * The Terrain Module.
 *   - Gets terrain data from JsonParser and converts it into an easier to work
 *      with interface by storing the data in abstract data structures.
 *)

(* Contains all the t_stats a terrain has/needs. Info from JSON. *)
type t_stats = {name:string; atkBonus:int; defBonus:int; img: Sprite.image}
(* Type of the terrain tells which units can travel through it.*)
type terrain = Impassable | Sea of t_stats | Plain of t_stats
              | Mountain of t_stats | City of t_stats
              | Forest of t_stats

(* [get_terrain class] returns an arbitrary terrain that of the class [class].
 *  (i.e. get_terrain "grass" will get a grass terrain, whose t_stats are found in the JSON)
 *
 *  Note: for terrain [class] is mapped to a terrain in the JSON
 *)
val get_terrain : int -> terrain


(*getters*)
val get_atkBonus: terrain -> int
val get_defBonus: terrain -> int
(* [draw t (x,y)] draws the terrain's image at (x,y) *)
val draw : terrain -> (int*int) -> unit