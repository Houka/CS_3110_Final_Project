open Feunit
open Terrain
open Constants
(* open PathFinder  *)(* pathfinder has find_units *)

type cursor = {x: int; y: int; color: int}

(* types of menus that player can have *)
type menu = {mutable selections:string list; mutable selected:int}
type menu_option = Null | Wait | End | Attack | Move
let selection_menu = {selections = ["Wait";"End Turn";"Attack";"Move"]; selected = 0}

(* player vars *)
let player_cursor = ref {x=0;y=0;color=colorNormal}
let temp_cursor = ref {x=0;y=0;color=colorNormal}
let selected = ref false
let moving = ref false
let attacking = ref false

let get_cursor () : cursor = !player_cursor

(* offsets the player's cursor with (x,y). Note: topleft is *)
let move_cursor_x cursor x : unit =
  let max_x = Constants.(gameWidth/gridSide) in
  let c = !cursor in

  (* x boundary conditions *)
  if c.x + x >= max_x-1
  then
        (InputManager.add_map_offset 1 0;
        cursor := {x=max_x-1; y=c.y; color=c.color})
  else if c.x + x <= 0
    then
          (InputManager.add_map_offset (-1) 0;
          cursor := {x=0; y=c.y; color=c.color})
    else cursor := {x=c.x+x; y=c.y; color=c.color}

let move_cursor_y cursor y : unit =
  let max_y = Constants.(gameHeight/gridSide) in
  let c = !cursor in
  (* y boundary conditions *)
  if c.y + y >= max_y-1
  then
        (InputManager.add_map_offset 0 1;
        cursor := {x=c.x; y=max_y-1; color=c.color})
  else if c.y + y <= 0
    then
          (InputManager.add_map_offset 0 (-1);
          cursor := {x=c.x; y=0; color=c.color})
    else cursor := {x=c.x; y=c.y+y; color=c.color}

(* Returns a selection menu with all the possible actions you can do on the element
 *  that you have selected
 *)
let construct_selection (u:feunit) : unit =
  match u with
  | Null | Enemy _ -> selection_menu.selections <- ["End Turn"]
  | Ally stats->
    if get_hasMoved u
    then selection_menu.selections <- ["Wait";"End Turn";"Attack"]
    else if get_endturn u
      then selection_menu.selections <- ["End Turn"]
      else selection_menu.selections <- ["Wait";"End Turn";"Attack";"Move"]

(* translates points from bottom left coordinate system to top left system *)
let translate_pt (x,y) : int*int =
  let x' = (x*Constants.gridSide) in
  let y' = (-y-1+Constants.(gameHeight/gridSide))*Constants.gridSide-1 in
  (x',y')

(* gets the center x,y pos of the player's selection box *)
let get_center_pt (): int*int =
  let cursor = get_cursor() in
  let (x,y) = translate_pt (cursor.x,cursor.y) in
  let x' = x+Constants.gridSide/2 in
  let y' = y+Constants.gridSide/2 in
  (x',y')

let draw_selection () : unit =
  if !selected then
  let (centerX, centerY) = get_center_pt() in
    let (longestWidth, longestHeight) =
        Hub.get_longest_string_dim selection_menu.selections in
    let draw_strings a = () in

    (* draws selection containment box *)
    Graphics.set_color 0xFFFFFF;
    Graphics.fill_rect centerX centerY longestWidth
                      (longestHeight*List.length selection_menu.selections);

    (* draw selected option *)
    Graphics.set_color 0xCCCCCC;
    Graphics.fill_rect centerX (centerY+selection_menu.selected*longestHeight)
                      longestWidth longestHeight;

    (* draw text options *)
    Graphics.set_color 0x222222;
    draw_strings (
      List.fold_right (
        fun x a -> Hub.draw_string x (centerX,centerY+a*longestHeight); a+1
      ) selection_menu.selections 0
    )
  else
    ()

let draw () : unit =
  let c = get_cursor() in
  let (cX, cY) = translate_pt (c.x,c.y) in
  (* drawing the player cursor *)
  Graphics.set_color (c.color);
  Graphics.draw_rect cX cY (Constants.gridSide) (Constants.gridSide);

  (* drawing the selection menu *)
  draw_selection ()

(* resets all ref vars *)
let reset () = let c = get_cursor() in
                player_cursor := {x=c.x; y=c.y; color=colorNormal};
                selection_menu.selected <- 0;
                selected := false;
                moving := false;
                attacking := false;
                ()

(* how to handle updating the units and terrain when we enter select mode *)
(*Draws a box containing vertical list of options, draw rectangles draw string
*)
let select_event (u :feunit) (t: terrain): menu_option =
  let selected' = selection_menu.selected in
  let menuLength =List.length (selection_menu.selections) in
  match (InputManager.get_keypressed (),InputManager.get_key ()) with
  | (true,'s') -> selection_menu.selected <-
                    if selected' - 1 < 0
                    then 0
                    else selected' - 1;
                    Null
  | (true,'w') -> selection_menu.selected <-
                    if selected' + 1 > menuLength - 1
                    then menuLength - 1
                    else selected' + 1;
                    Null
  | (true,'j') -> let result =
    match List.nth selection_menu.selections (menuLength - 1 - selected') with
    | "Wait" -> Wait
    | "End Turn" -> End
    | "Attack" -> attacking:= true; Attack
    | "Move" -> moving:=true; Move
    | _ -> Null in
    result
  | (true,'k') -> reset ();
                  Null
  | _ -> Null


(* how to handle a deselect event *)
let deselect_event (units :feunit matrix) (terrains: terrain matrix)
  : Constants.action list =
  (* updating player cursor *)
  match (InputManager.get_keypressed (),InputManager.get_key ()) with
  | (true,'w') -> move_cursor_y player_cursor (-1); []
  | (true,'a') -> move_cursor_x player_cursor (-1); []
  | (true,'s') -> move_cursor_y player_cursor (1); []
  | (true,'d') -> move_cursor_x player_cursor (1); []
  | (true,'j') -> let c = get_cursor() in
                  let (offX, offY) = InputManager.get_map_offset () in
                  player_cursor := {x=c.x; y=c.y; color=colorSelected };
                  construct_selection (PathFinder.grab units (c.x+offX,c.y+offY));
                  selected := true; []
  | _ -> []

(* how to handle the cursor when selecting a place for unit to move *)
let move (units :feunit matrix) (terrains: terrain matrix)
  : Constants.action list =
  (* updating player cursor *)
  match (InputManager.get_keypressed (),InputManager.get_key ()) with
  | (true,'w') -> move_cursor_y temp_cursor (-1); []
  | (true,'a') -> move_cursor_x temp_cursor (-1); []
  | (true,'s') -> move_cursor_y temp_cursor (1); []
  | (true,'d') -> move_cursor_x temp_cursor (1); []
  | (true,'j') -> failwith "TODO"
  | (true,'k') -> reset (); []
  | _ -> []

(* how to handle the cursor when selecting someone to attack *)
let attack (units :feunit matrix) (terrains: terrain matrix)
  : Constants.action list =
  (* updating player cursor *)
  match (InputManager.get_keypressed (),InputManager.get_key ()) with
  | (true,'w') -> move_cursor_y temp_cursor (-1); []
  | (true,'a') -> move_cursor_x temp_cursor (-1); []
  | (true,'s') -> move_cursor_y temp_cursor (1); []
  | (true,'d') -> move_cursor_x temp_cursor (1); []
  | (true,'j') -> failwith "TODO"
  | (true,'k') -> reset (); []
  | _ -> []

let update (units :feunit matrix) (terrains: terrain matrix)
  : Constants.action list =
  let (offX, offY) = InputManager.get_map_offset () in
  let cursor = get_cursor() in
  if !selected then
    let u = PathFinder.grab units (cursor.x+offX,cursor.y+offY) in
    let t = PathFinder.grab terrains (cursor.x+offX,cursor.y+offY) in
    match select_event u t with
    | Null -> []
    | Move -> temp_cursor := !player_cursor; move units terrains
    | Attack -> temp_cursor := !player_cursor; attack units terrains
    | End -> selected:=false;
            construct_selection u;
            selection_menu.selected <- 0;
            [Endturn]
    | Wait -> selected:=false;
            construct_selection u;
            selection_menu.selected <- 0;
            [Wait (cursor.x+offX,cursor.y+offY)]
  else
    deselect_event units terrains

