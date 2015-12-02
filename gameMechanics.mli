open Terrain
open Feunit
open Level
(*
 *  The GameMechanics Module:
 *    - Enforces game rules on AI and Player.
 *    - Contains functions that AI and Player must use in order to manipulate
 *      the units on the field. Each function here will represent a legal
 *      move that any player can do.
 *)

(* Set the contents that this module will be working with *)
val set_units: feunit array array -> unit
val set_map: terrain array array -> unit

(* Draw the screen after turns are applied *)
val draw: unit -> unit

(* Update the level's current state and all its elements by one turn. Its task
 * is to gather instructions from all players (AI included) and act on those
 * instructions. If the instruction provided is an invalid action (based on the
 * game rules enforced here) then an exception will be thrown.
 * Note: returns 1 if you have won the level, -1 if you lost, 0 otherwise.
 *)
val update: unit -> int

(* [attack (x1,y1) (x2,y2)] will enforce game machanics and rules as it applies
 * an attack from the unit at location (x1,y1) to the unit at location (x2,y2).
 * It applies the attack on the units matrix. If the attack is not allowed it
 * will fail with an exception else it will apply damage calculated from terrain
 * bonuses and from [u1] to [u2] and apply that to the unit matrix.
 *
 * A valid attack is the following:
 *   - Units exist at (x1,y1) and (x2,y2)
 *   - Unit at (x1,y1) has endturn = false
 *   - Unit at (x2,y2) is in the attack range of unit at (x1,y1)
 *   - Unit at (x2,y2) is an enemy of unit at (x1,y1)
 *
 * (ex: if a attacks b but b is not in attack range of a then throw exception)
 *)
val attack_unit: (int*int) -> (int*int) -> unit

(* [move (x1,y1) (x2,y2))] apply the action of moving from a unit at (x1,y1) to
 * a position (x2,y2). Before it applies this movement on the units matrix, it
 * must check that it is a valid move.
 *
 * A valid move is the following:
 *   - Unit exists at (x1,y1)
 *   - Unit at (x1,y1) has endturn = false
 *   - No other unit is at that position
 *   - At the path to that position, the terrain is traversible by the unit
 *   - Moving to (x2,y2) is in the range of the unit's movement range
 *   - There is a terrain at that position
 *)
val move: int * int -> int * int -> unit

(* [wait (x,y)] alters the unit at x,y in the matrix so its endturn attribute
 * says it has finished its turn. *)
val wait: int*int -> unit