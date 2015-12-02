(*
 *  The InputManager module
 *    - Gets the most updated input from the user and acts as a hub for all
 *       other modules to get the input information from
 *)

(* setters and getters to manage information flow *)
val set_keypressed: bool -> char -> unit
val get_keypressed: unit -> bool
val get_key: unit -> char

(* setters and getters to manage moving of the game map. works on relative vectors. *)
val get_map_offset: unit -> (int*int)
val set_map_limits: int -> int -> unit

(* resets the offset *)
val reset_map_offset: unit -> unit

(*  [add_map_offset x y] changes the offset so map can be draw at specified offset
    postC: offset stays in limits of map_limits *)
val add_map_offset: int -> int -> unit