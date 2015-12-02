open Constants
open Feunit
open Terrain

(*
 * The pathFinder Module:
 *   - Handles finding possible moves given a unit
 *   - Handles finding the shortest path given start and end
 *)

type dest_path = {start: (int * int);
                  destination: (int * int);
                  mutable cost: int;
                  mutable path: (int * int) list}

(* Grab the element in the matrix at a particular coordinate. *)
val grab : 'a matrix -> (int * int) -> 'a

(* Return list of all ally and enemy units given unit and terrain matrix. *)
val find_units : feunit matrix -> ((int * int) list * (int * int) list)

(* Return a record containing the start, destination, cost, and path of one unit
 * to another unit.  *)
val shortest_path : (int * int) -> (int * int) -> int -> feunit matrix ->
                     terrain matrix -> dest_path

(* Return a list of all available coordinates a unit can travel to given its
 * original location *)
val find_paths : feunit matrix -> terrain matrix -> (int * int) ->
                 (int * int) list

(* Return a list of all available coordinates a unit can attack given its
 * original location *)
val find_attack: feunit matrix -> terrain matrix -> (int * int) ->
                 (int * int) list
