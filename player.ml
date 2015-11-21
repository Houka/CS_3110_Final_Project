open Feunit
open Terrain
open Graphics

type cursor = {x: int; y: int; color: int}

(* player vars *)
let player_cursor = ref {x=0;y=0;color=0xFF0000}
let selected = ref false

(* finds player units to move*)
let find_player_units (units:feunit list) : feunit list = failwith "TODO"

let get_cursor () : cursor = !player_cursor

(* how to handle updating the units and terrain when we enter select mode *)
(*Draws a box containing vertical list of options, draw rectangles draw string
*)
let select_event (units :feunit list list) (terrains: terrain list list)
  : Constants.action list =
    match (InputManager.get_keypressed (),InputManager.get_key ()) with
    | (true,'j') -> failwith "TODO"
    | (true,'k') -> selected := false; []
    | _ -> failwith "TODO" (* keyboard inputs to make option menu *)


(* how to handle a deselect event *)
let deselect_event (units :feunit list list) (terrains: terrain list list)
  : Constants.action list =
  let cursor = get_cursor() in
  (* updating player cursor *)
  match (InputManager.get_keypressed (),InputManager.get_key ()) with
  | (true,'w') ->
    let side = if cursor.y + Constants.gridSide >= size_y ()
               then 0 else Constants.gridSide in
    player_cursor := {x=cursor.x;y=(cursor.y + side);color=0xFFFFFF};
    []
  | (true,'a') ->
    let side = if cursor.x <= 0 then 0 else Constants.gridSide in
    player_cursor := {x=(cursor.x - side);y=cursor.y;color=0xFFFFFF};
    []
  | (true,'s') ->
    let side = if cursor.y <= 0 then 0 else Constants.gridSide in
    player_cursor := {x=cursor.x;y=(cursor.y - side);color=0xFFFFFF};
    []
  | (true,'d') ->
    let side = if cursor.x + Constants.gridSide >= size_x ()
               then 0 else Constants.gridSide in
    player_cursor := {x=(cursor.x + side);y=cursor.y;color=0xFFFFFF};
    []
  | (true,'j') -> selected := true; []
  | _ -> []


let draw () : unit =
  (* drawing the player cursor *)
  set_color 0xFF0000;
  fill_rect ((get_cursor()).x) ((get_cursor()).y) (Constants.gridSide) (Constants.gridSide)

let update (units :feunit list list) (terrains: terrain list list)
  : Constants.action list =
  if !selected then
    select_event units terrains
  else
    deselect_event units terrains

