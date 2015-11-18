(*
 *  The InputManager module
 *    - Gets the most updated input from the user and acts as a hub for all
 *       other modules to get the input information from
 *)

(* setters and getters to manage information flow *)
val set_keypressed: bool -> char -> unit
val get_keypressed: unit -> bool
val get_key: unit -> char