open Terrain
open Feunit
open Constants
open Ai
open Player

let turn = ref 0
let currentUnits = ref [||]
let currentTerrains = ref [||]

(*check if a unit exists at point x,y*)
let exists (x,y) =
  if !currentUnits.(y).(x) <> Null then true else false

let get_unit (x,y) =
  if !currentUnits.(y).(x) <> Null then !currentUnits.(y).(x) else failwith
      "unit doesn't exist at location"

let get_terrain (x,y) =
  !currentTerrains.(y).(x)

let in_range (x1, y1) (x2, y2) range =
  (y2-y1+x2-x1) <= range

let opposite_sides (a:feunit) (b:feunit) =
  match a, b with
  | Ally _, Enemy _ -> true
  | Enemy _, Ally _ -> true
  | _ -> false

(* legal actions *)
let attack_unit (x1,y1) (x2,y2): unit =
  let unit1 = get_unit (x1,y1) in
  let unit2 = get_unit (x2,y2) in
  if not (opposite_sides unit1 unit2) then failwith "units are allied" else
  if get_endturn unit1 then failwith "unit cannot attack, turn is over" else
  if (not (in_range (x1,y1) (x2, y2) (get_total_range unit1)))
    then failwith "unit2 out of range of attack"
  else

    let (a,b) = attack unit1 unit2 in
    let () =
    if b = Null then !currentUnits.(y2).(x2) <- Null
    else
    (*counterattack*)
      if (in_range (x2,y2) (x1, y1) (get_total_range unit2)) then
        let (c,d) = attack b a in
        if d = Null then !currentUnits.(y1).(x1) <- Null else ()
      else ()
    in set_endturn unit1 true


let move (x1,y1) (x2,y2) : unit =
  (* let u = get_unit (x1,y1) in
  if get_endturn u then failwith "unit cannot move, turn is over" else
  let path = stuff in
  if ____ then let terrain1 = get_terrain (x2,y2) in
              set_atk_bonus unit1 (get_atkBonus terrain1);
              set_def_bonus unit1 (get_defBonus terrain1);
              set_hasMoved unit1 true
  else failwith "not a valid move" *)

  failwith "TODO"

let endturns : unit =
  failwith "TODO"

let wait (u: feunit) : unit =
  let endturn = get_endturn u in
  if endturn then failwith "This unit's turn is over" else set_endturn u false

let set_units (feunits:feunit array array) : unit =
  currentUnits := feunits;
  turn := 0
let set_map (map:terrain array array) : unit =
  currentTerrains := map;
  turn := 0

(* converts an 'a array array to 'a matrix *)
let to_2d_list (matrix: 'a array array) : 'a matrix =
  let first_layer = Array.to_list matrix in
  List.map (fun a -> Array.to_list a) first_layer

(* private getters *)
let get_units () : feunit matrix =
  to_2d_list !currentUnits
let get_map () : terrain matrix =
  to_2d_list !currentTerrains

(* increments the turn counter *)
let inc_turn (): unit  = turn := !turn + 1

(* performs the actions list and updates the map and units based on the actions*)
let perform_actions (actions: action list) : unit =
  failwith "TODO"

(* Goes through each terrain in currentTerrains and calls their draw functions *)
let draw_terrain () : unit =
  failwith "TODO"

(* Goes through each unit in currentUnits and calls their draw functions *)
let draw_unit () : unit =
  failwith "TODO"

let draw () : unit =
  (* draw map objects first *)
  draw_terrain ();
  draw_unit ();

  (* for Player's cursor drawings *)
  Player.draw();

  (* for Hub drawings *)
  let cursor = Player.get_cursor () in
  let highlightedUnit = !currentUnits.(cursor.y).(cursor.x) in
  let highlightedTerrain = !currentTerrains.(cursor.y).(cursor.x) in
  Hub.draw_unit_stats highlightedUnit;
  Hub.draw_terrain_stats highlightedTerrain

let update () : unit =
  let actions =
    if !turn mod 2 = 0
    then Player.update (get_units ()) (get_map ())
    else failwith "TODO" (* Ai.update (get_units ()) (get_map ()) *) in

  inc_turn ();
  perform_actions actions