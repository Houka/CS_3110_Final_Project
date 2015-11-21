open Feunit
open Terrain
open Level
open Async.Std

(* mutable var to keep track of level state *)
let currentState = ref "menu"
let levelData = ref (Ivar.create ())

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
  upon (return l) (fun a -> Ivar.fill !levelData a);
  upon (return(construct_feunit_matrix l.unit_matrix)) (GameMechanics.set_units);
  upon (return(construct_terrain_matrix l.terrain_matrix)) (GameMechanics.set_map)

let loaded () : bool =
  not (Ivar.is_empty !levelData) && GameMechanics.loaded ()

let get_current_state () : string = !currentState

let set_current_state (statename : string) : unit =
  currentState := statename;
  set_level_data statename

let update () : unit =
  (* testing *)
  GameMechanics.update ()

let draw () : unit =
  (* testing *)
  Player.draw()

