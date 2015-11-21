open Feunit
open Terrain
open Level
open Async.Std

(* mutable var to keep track of level state *)
let currentState = ref "menu"

(* contructs unit and terrain matrices that shows the position of the unit
    or terrain in the map
 *)
let construct_terrain_matrix matrix =
  let traverse_rows a x =
    let nrow =
      List.fold_left (fun a' x' -> Array.append a' [|(get_terrain x')|]) [||] x in
    Array.append a [|nrow|] in
  List.fold_left (traverse_rows) [||] matrix

let construct_feunit_matrix matrix =
  let traverse_rows a x =
    let nrow =
      List.fold_left (fun a' x' ->
        let newunit = (get_unit x') in
        Array.append a' [|newunit|]
      ) [||] x in
    Array.append a [|nrow|] in
  List.fold_left (traverse_rows) [||] matrix

(* Takes in a [levelname] then gets that level's data from the Level module,
 *  constructs the level by assigning currentState with [levelname],
 *  construct a list of units based on info from the Level and assigns that to
 *  currentUnits, finally constructs a list of terrains based on info from the
 *  Level and assigns it to currentTerrains
 *)
let set_level_data (levelname: string) : unit =
  let l = get_level levelname in
  GameMechanics.set_units (construct_feunit_matrix l.unit_matrix);
  GameMechanics.set_map (construct_terrain_matrix l.terrain_matrix)

let get_current_state () : string = !currentState

let set_current_state (statename : string) : unit =
  currentState := statename;
  set_level_data statename

let update () : unit =
  GameMechanics.update ()

let draw () : unit =
  GameMechanics.draw();

