(*
 * The Feunit Module.
 *   - Gets unit data from JsonParser and converts them into an easier to work
 *      with interface by storing the data in abstract data structures.
 *)

(* Contains all the stats a typical unit has/needs. Info from JSON. *)
type stats = { name: string; maxHp: int;
              atk: int; def: int; atkRange: int; movRange: int;
              mutable hp: int; mutable atkBonus: int; mutable defBonus: int;
              mutable atkRangeBonus: int; mutable movRangeBonus: int;
              weapon: string; img: Sprite.image; endturn: bool }
(* Represents a fire emblem unit *)
type feunit = Null | Ally of stats | Enemy of stats

(* [get_unit class] returns an arbitrary feunit that is of the class [class].
 *  (i.e. get_unit 1 will get an archer, if class 1 cooresponds to archer in the JSON)
 *)
val get_unit : int -> feunit

(* self explanatory functions *)
val set_atk_bonus : feunit -> int -> unit
val set_def_bonus : feunit -> int -> unit
val set_mov_bonus : feunit -> int -> unit
val set_range_bonus : feunit -> int -> unit
val add_hp : feunit -> int -> unit (* note: can add negatives, duh *)

(* getters *)
val get_total_atk : feunit -> int
val get_total_def : feunit -> int
val get_total_mov : feunit -> int
val get_total_range : feunit -> int
val get_percent_hp : feunit -> int (* hp/maxHp * 100 *)
