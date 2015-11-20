(*
 * The Feunit Module.
 *   - Gets unit data from JsonParser and converts them into an easier to work
 *      with interface by storing the data in abstract data structures.
 *)

(* Contains all the stats a typical unit has/needs. Info from JSON. *)
type stats = { name: string; maxHp: int;
              atk: int; def: int; atkRange: int; movRange: int;
              hp: int; atkBonus: int; defBonus: int; atkRangeBonus: int;
              movRangeBonus: int; weapon:string; img: Images.t;
              endturn: bool}
(* Represents a fire emblem unit *)
type feunit = Ally of stats | Enemy of stats

(* [get_unit class] returns an arbitrary feunit that is of the class [class].
 *  (i.e. get_unit 1 will get an archer, if class 1 cooresponds to archer in the JSON)
 *)
val get_unit : int -> feunit

(* self explanatory functions *)
val add_atk_bonus : feunit -> int -> feunit
val add_def_bonus : feunit -> int -> feunit
val add_mov_bonus : feunit -> int -> feunit
val add_range_bonus : feunit -> int -> feunit
val add_hp : feunit -> int -> feunit (* note: can add negatives, duh *)

(* getters *)
val get_total_atk : feunit -> int
val get_total_def : feunit -> int
val get_total_mov : feunit -> int
val get_total_range : feunit -> int
val get_percent_hp : feunit -> int (* hp/maxHp * 100 *)
