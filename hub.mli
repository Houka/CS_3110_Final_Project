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
val drawUnitStats : feunit -> unit

(* Draws to the GUI all necessary stats on the given terrain *)
val drawTerrainStats : terrain -> unit

(* Draws to the GUI the level stats (i.e lvl title) *)
val drawLevelStats: level -> unit

(* Draws a display string on the top lvl og the GUI *)
val drawString: string -> unit