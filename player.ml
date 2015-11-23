open Feunit
open Terrain
open Constants
(* open PathFinder  *)(* pathfinder has find_units *)

type cursor = {x: int; y: int; color: int}

(* types of menus that player can have *)
let selection_menu = ref ["Wait";"End Turn";"Attack";"Move"]

(* player vars *)
let player_cursor = ref {x=0;y=0;color=0xFF0000}
let selected = ref false

let get_cursor () : cursor = !player_cursor

(* offsets the player's cursor with (x,y). Note: topleft is *)
let move_player_cursor_x x : unit =
  let max_x = Constants.(gameWidth/gridSide) in
  let c = get_cursor () in

  (* x boundary conditions *)
  if c.x + x >= max_x-1
  then player_cursor := {x=max_x-1; y=c.y; color=c.color}
  else if c.x + x <= 0
    then player_cursor := {x=0; y=c.y; color=c.color}
    else player_cursor := {x=c.x+x; y=c.y; color=c.color}

let move_player_cursor_y y : unit =
  let max_y = Constants.(gameHeight/gridSide) in
  let c = get_cursor () in
  (* y boundary conditions *)
  if c.y + y >= max_y-1
  then player_cursor := {x=c.x; y=max_y-1; color=c.color}
  else if c.y + y <= 0
    then player_cursor := {x=c.x; y=0; color=c.color}
    else player_cursor := {x=c.x; y=c.y+y; color=c.color}

(* Returns a selection menu with all the possible actions you can do on the element
 *  that you have selected
 *)
let construct_selection (u:feunit) (t:terrain) : unit = failwith "TODO"

(* how to handle updating the units and terrain when we enter select mode *)
(*Draws a box containing vertical list of options, draw rectangles draw string
*)
let select_event (u :feunit) (t: terrain): Constants.action list =
  construct_selection u t;
  match (InputManager.get_keypressed (),InputManager.get_key ()) with
  | (true,'w') -> failwith "TODO"
  | (true,'a') -> failwith "TODO"
  | (true,'s') -> failwith "TODO"
  | (true,'d') -> failwith "TODO"
  | (true,'j') -> failwith "TODO"
  | (true,'k') -> selected := false; []
  | _ -> failwith "TODO" (* keyboard inputs to make option menu *)


(* how to handle a deselect event *)
let deselect_event (units :feunit matrix) (terrains: terrain matrix)
  : Constants.action list =
  (* updating player cursor *)
  match (InputManager.get_keypressed (),InputManager.get_key ()) with
  | (true,'w') -> move_player_cursor_y (-1); []
  | (true,'a') -> move_player_cursor_x (-1); []
  | (true,'s') -> move_player_cursor_y (1); []
  | (true,'d') -> move_player_cursor_x (1); []
  | (true,'j') -> selected := true; []
  | _ -> []

(* gets the center x,y pos of the player's selection box *)
let get_center_pt (): int*int =
  let cursor = get_cursor() in
  (cursor.x*Constants.gameWidth+Constants.gridSide/2,
  cursor.y*Constants.gameHeight+Constants.gridSide/2)

let draw () : unit =
  (* drawing the player cursor *)
  Graphics.set_color 0xFF0000;
  Graphics.fill_rect ((get_cursor()).x*Constants.gridSide)
        ((-(get_cursor()).y-1+Constants.(gameHeight/gridSide))*Constants.gridSide)
        (Constants.gridSide) (Constants.gridSide)

  (* drawing the selection menu *)
  (* if !selected then
    let draw_option (x:string) () : unit =
      Hub.draw_string
    List.fold_right (draw_option) selection_menu ()
  else
    () *)

let update (units :feunit matrix) (terrains: terrain matrix)
  : Constants.action list =
  (* let cursor = get_cursor() in *)
  if !selected then(*
    let u = grab units (cursor.x) (cursor.y) in
    let t = grab terrains (cursor.x) (cursor.y) in *)
    select_event (List.(hd (hd units))) List.(hd (hd terrains))
  else
    deselect_event units terrains

