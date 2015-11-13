open Feunit
open Terrain

(*
 * The Hub Module.
 *   - Handles drawing information regarding a selected element on the
 *      game screen. (Ex: when the player has his in-game selector on a unit
 *      in the game window, the hub will draw and display the stats of the unit
 *      in a meaningful way--such as a bar to represent current health)
 *)

(* Draws to the GUI all necessary stats on the given unit *)
val draw_unit_stats : feunit -> unit

(* Draws to the GUI all necessary stats on the given terrain *)
val draw_terrain_stats : terrain -> unit

(* Draws to the GUI the level stats (i.e lvl title) *)
val draw_level_stats: level -> unit

(* Draws a display string on the top lvl og the GUI *)
val draw_string: string -> unit