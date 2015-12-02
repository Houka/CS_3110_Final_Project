(*
 * The Feunit Module:
 *   - Gets unit data from JsonParser and converts them into a more convenient
 *     interface to work with by storing the data in abstract data structures.
 *)

(* Contain all the stats a typical unit has/needs. Info from JSON. *)
type stats = { name: string; maxHp: int;
              atk: int; def: int; atkRange: int; movRange: int;
              mutable hp: int; mutable atkBonus: int; mutable defBonus: int;
              mutable atkRangeBonus: int; mutable movRangeBonus: int;
              weapon: string; img: Sprite.image; mutable endturn: bool;
              mutable hasMoved : bool}

(* Represent a fire emblem unit. *)
type feunit = Null | Ally of stats | Enemy of stats

(* [get_unit class] returns an arbitrary feunit that is of the class [class].
 * (i.e. get_unit 1 will get an archer, if class 1 corresponds to archer in the
 * JSON)
 *)
val get_unit : int -> feunit

(* Self explanatory functions *)
val set_atk_bonus : feunit -> int -> unit
val set_def_bonus : feunit -> int -> unit
val set_mov_bonus : feunit -> int -> unit
val set_range_bonus : feunit -> int -> unit
val set_endturn : feunit -> bool -> unit
val set_hasMoved: feunit -> bool -> unit
val add_hp : feunit -> int -> unit (* note: can add negatives, duh *)

(* Getters *)
val get_total_atk : feunit -> int
val get_total_def : feunit -> int
val get_total_mov : feunit -> int
val get_total_range : feunit -> int
val get_percent_hp : feunit -> int (* hp/maxHp * 100 *)
val get_hp : feunit -> int
val get_weapon : feunit -> string
val get_endturn : feunit -> bool
val get_hasMoved: feunit -> bool

(* [draw u (x,y)] draws the unit's image at (x,y). *)
val draw : feunit -> (int*int) -> unit

(* Attack a b carries out an attack from a on b. *)
val attack: feunit -> feunit -> feunit*feunit