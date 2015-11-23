open Constants
open Feunit
open Terrain

(*
 * The pathFinder Module.
 *   - Handles finding possible moves given a unit
 *   - Handles finding the shortest path given start and end
 *)

type dest_path = {start: (int * int);
                  destination: (int * int);
                  mutable cost: int;
                  mutable path: (int * int) list}

val grab : 'a matrix -> (int * int) -> 'a

val find_units : feunit matrix -> ((int * int) list * (int * int) list)

val shortest_path :  (int * int) -> (int * int) -> feunit matrix ->
                      terrain matrix -> dest_path

val find_paths : feunit matrix -> terrain matrix -> (int * int) -> (int * int) list