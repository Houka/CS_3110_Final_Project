open Feunit
open Terrain
open Graphics

type cursor = {x: int; y: int; color: int}

(* player vars *)
let player_cursor = ref {x=0;y=0;color=0xFF0000}
let selected = ref false

(* player constants *)
let side = 100

(* finds player units to move*)
let find_player_units (units:feunit list) : feunit list = failwith "TODO"

let get_cursor () : cursor = !player_cursor

(* how to handle updating the units and terrain when we enter select mode *)
let select (units :feunit list ref) (terrains: terrain list ref) : unit =
  selected := true;
  failwith "TODO"

(* how to handle a deselect event *)
let deselect () : unit =
  selected := false;
  failwith "TODO"

let draw () : unit =
  (* drawing the player cursor *)
  set_color 0xFF0000;
  fill_rect ((get_cursor()).x) ((get_cursor()).y) (side) (side)

let update (keypressed,key) (units :feunit list ref) (terrains: terrain list ref) : unit =
  let cursor = get_cursor() in
  (* updating player cursor *)
  match (keypressed,key) with
  | (true,'w') ->
    let side = if cursor.y + side >= size_y () then 0 else side in
    player_cursor := {x=cursor.x;y=(cursor.y + side);color=0xFFFFFF}
  | (true,'a') ->
    let side = if cursor.x <= 0 then 0 else side in
    player_cursor := {x=(cursor.x - side);y=cursor.y;color=0xFFFFFF}
  | (true,'s') ->
    let side = if cursor.y <= 0 then 0 else side in
    player_cursor := {x=cursor.x;y=(cursor.y - side);color=0xFFFFFF}
  | (true,'d') ->
    let side = if cursor.x + side >= size_x () then 0 else side in
    player_cursor := {x=(cursor.x + side);y=cursor.y;color=0xFFFFFF}
  | (true,'j') -> select units terrains
  | (true,'k') -> deselect ()
  | _ -> ()


