open Terrain
open Feunit
open Constants
open Ai
open Player

let turn = ref 0
let currentUnits = ref [||]
let currentTerrains = ref [||]


(* legal actions *)
let attack (u1: feunit) (x1,y1) (u2: feunit) (x2,y2): unit =
  failwith "TODO"
let move (u1: feunit) (x1,y1) (x2,y2) : unit =
  failwith "TODO"
let wait (u1: feunit) : unit =
  failwith "TODO"

let set_units (feunits:feunit array array) : unit =
  currentUnits := feunits;
  turn := 0
let set_map (map:terrain array array) : unit =
  currentTerrains := map;
  turn := 0

(* converts an 'a array array to 'a list list *)
let to_2d_list (matrix: 'a array array) : 'a list list =
  let first_layer = Array.to_list matrix in
  List.map (fun a -> Array.to_list a) first_layer

(* private getters *)
let get_units () : feunit list list =
  to_2d_list !currentUnits
let get_map () : terrain list list =
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
    else Ai.update (get_units ()) (get_map ()) in

  inc_turn ();
  perform_actions actions
