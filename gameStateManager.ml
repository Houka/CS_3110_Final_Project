open Feunit
open Terrain
open Level
open Async.Std

(* mutable var to keep track of level state (current state, next state) *)
let state = ref ("tutorial","tutorial")

(* contructs unit and terrain matrices that shows the position of the unit
    or terrain in the map
 *)
let construct_terrain_matrix matrix =
  let traverse_rows a x =
    let nrow =
      List.fold_left (fun a' x' ->
        let newterrain = (get_terrain x') in
        Array.append a' [|newterrain|]
      ) [||] x in
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

(* apply the terrain bonuses to each unit *)
let apply_bonus_to_units units terrains : unit=
  for y = 0 to (Array.length units)-1 do
    for x = 0 to (Array.length (units.(0)))-1 do
      let u = units.(y).(x) in
      match u with
      | Null -> ()
      | _ ->
        let t = match terrains.(y).(x) with
          | Impassable _-> failwith "Unit on Impassable terrain"
          | Sea t| Plain t| Mountain t| City t | Forest t -> t in
        set_atk_bonus u (t.atkBonus);
        set_def_bonus u (t.defBonus);
        set_mov_bonus u (0); (* unimplemented feature *)
        set_range_bonus u (0) (* unimplemented feature *)
    done
  done

(* Takes in a [levelname] then gets that level's data from the Level module,
 *  constructs the level by assigning currentState with [levelname],
 *  construct a list of units based on info from the Level and assigns that to
 *  currentUnits, finally constructs a list of terrains based on info from the
 *  Level and assigns it to currentTerrains
 *)
let set_level_data (levelname: string) : unit =
  let l = get_level levelname in
  let t = construct_terrain_matrix l.terrain_matrix in
  let u = construct_feunit_matrix l.unit_matrix in
  state := (levelname, l.next);
  Printf.printf ("You are on %s\n\nTurn 1: Player turn\n") levelname;
  apply_bonus_to_units u t;
  InputManager.set_map_limits (Array.length t.(0)) (Array.length t);
  GameMechanics.set_units (u);
  GameMechanics.set_map (t)

let update () : unit =
  match GameMechanics.update () with
  | 1 -> if (snd !state ) = "credits" then
           set_level_data (snd !state)
         else
           (Sprite.(draw (get_image "next_level") (0,0));
           set_level_data (snd !state);
           ignore(Graphics.(wait_next_event [Key_pressed])))
  | 0 -> if (fst !state) = "credits" then
           set_level_data (snd !state)
         else ()
  | -1 -> Sprite.(draw (get_image "lose") (0,0));
          set_level_data (fst !state)
  | _ -> ()

let draw () : unit =
  if (fst !state) = "credits" then
    Sprite.(draw (get_image "credits") (0,0))
  else
    GameMechanics.draw()

