open Feunit
open Terrain
open Level

(* mutable var to keep track of level state *)
let currentState = ref "menu"

(* Takes in a [levelname] then gets that level's data from the Level module,
 *  constructs the level by assigning currentState with [levelname],
 *  construct a list of units based on info from the Level and assigns that to
 *  currentUnits, finally constructs a list of terrains based on info from the
 *  Level and assigns it to currentTerrains
 *)
let get_level_data (levelname: string) : (level * feunit list * terrain list) =
  failwith "TODO"

let get_current_state () : string = !currentState

let set_current_state (statename : string) : unit = currentState := statename

let update () : unit =
  (* testing *)
  GameMechanics.update (get_level_data (get_current_state ()))

let draw () : unit =
  (* testing *)
  Player.draw()

