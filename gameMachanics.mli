open Terrain
open Feunit
(*
 *  The GameMachanics Module:
 *    - Enforces game rules on AI and Player.
 *    - Contains functions that AI and Play must use in order to manipulate
 *      the units on the field. Each function here will represent a legal
 *      move that any player can do.
 *)

(* [attack units terrains u1 u2] will enforce game machanics and rules as it
    applies an attack from [u1] to [u2]. It will return back an altered [u2]
    option. If [u1] attacking [u2] is not allowed it will return null else
    it will apply damage calculated from terrain bonuses and from [u1] to [u2]
    and return what [u2] will be like when that damage is applied.

    A valid attack is the following:
      - [u2] is in the attack range of [u1]
      - [u2] is an enemy of [u1]

    (ex: if a attacks b but b is not in attack range of a then None is returned)
    (ex: if a attacks b and the rules allow this then Some c will be returned
      where c is b but with lower hp)
 *)
val attack: terrain array -> feunit -> feunit -> feunit option

(* [move units terrains u1 (x,y)] apply the action of moving from [u1]'s current
    position to a position that is ([u1].x + x, [u1].y + y). In other words (x,y)
    are relative positions. Before it applies this movement and return an altered
    feunit of [u1] with the moved position, it must check that it is a valid move.

    A valid move is the following:
      - at that position, no other unit is there
      - at that position, the terrain is traversible by the unit
      - moving to (x,y) is in the range of the unit's movement range
      - there is a terrain at that position
*)
val move: feunit array -> terrain array -> feunit -> int * int -> feunit option

(* [wait u1] returns [u1] but altering its endturn attribute so that it has finished
    its turn.
 *)
val wait: feunit -> feunit