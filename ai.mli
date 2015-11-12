(*
 * The AI module
 *   - Sets commands for the units
 *)
type unit = {attack: int; defense: int; move: int; max_hp: int;
                mutable current_hp: int; weapon: string; image:string}
type terrain = {atk_bonus:int; def_bonus: int; image: string}

(* Returns a new game state by moving a unit *)
val move_unit : unit -> unit list list -> terrain list list ->
                (unit list list, terrain list list)

(* finds enemy units to move*)
val find_enemy_units: unit list list -> unit list