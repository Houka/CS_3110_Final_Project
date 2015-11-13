open Feunit
open Terrain

(* mutable var to keep track of level state *)
let currentState = ref "menu"
let currentUnits = ref []
let currentTerrains = ref []

(* Takes in a [levelname] then gets that level's data from the Level module,
 *  constructs the level by assigning currentState with [levelname],
 *  construct a list of units based on info from the Level and assigns that to
 *  currentUnits, finally constructs a list of terrains based on info from the
 *  Level and assigns it to currentTerrains
 *)
let construct_level (levelname: string) : unit = failwith "TODO"

let get_units () : feunit list ref = currentUnits
let get_terrains () : terrain list ref = currentTerrains

let get_current_state () : string = !currentState

let set_current_state (statename : string) : unit = currentState := statename

let update () : unit = failwith "TODO"

let draw () : unit = failwith "TODO"

