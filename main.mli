(*
 * The Main Module.
 *   - Handles updating all other modules that will be used.
 *   - Handles initialization of GUI
 *   - Handles getting User Input and saves that information off
 *      for other modules to access.
 *)

(* Returns true if the last user input was a keypress *)
val get_keypressed : unit -> bool

(* Returns the char representing the key of the last user keypress *)
val get_key : unit -> char



