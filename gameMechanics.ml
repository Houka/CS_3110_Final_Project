open Terrain
open Feunit
open Constants
open PathFinder
open Player

let turn = ref 0
let currentUnits = ref [||]
let currentTerrains = ref [||]

let num_allies = ref 0
let num_enemies = ref 0
let num_usable_units = ref 1

(* converts an 'a array array to 'a matrix *)
let to_2d_list (matrix: 'a array array) : 'a matrix =
  let first_layer = Array.to_list matrix in
  List.map (fun a -> Array.to_list a) first_layer

(* private getters *)
let get_units () : feunit matrix =
  to_2d_list !currentUnits
let get_map () : terrain matrix =
  to_2d_list !currentTerrains


(*check if a unit exists at point x,y*)
let exists (x,y) =
  if !currentUnits.(y).(x) <> Null then true else false

let get_unit (x,y) =
  if !currentUnits.(y).(x) <> Null
  then !currentUnits.(y).(x)
  else Null

let get_terrain (x,y) =
  !currentTerrains.(y).(x)

let in_range (x1, y1) (x2, y2) range =
  let xdiff = abs (x2-x1) in
  let ydiff = abs (y2-y1) in
  xdiff + ydiff <= range

let opposite_sides (a:feunit) (b:feunit) =
  match a, b with
  | Ally _, Enemy _ -> true
  | Enemy _, Ally _ -> true
  | _ -> false

let type_of (u:feunit):string =
  match u with
  |Ally _ -> "Ally"
  |Enemy _ -> "Enemy"
  |Null -> "Null"
(* legal actions *)
let attack_unit (x1,y1) (x2,y2): unit =
  let unit1 = get_unit (x1,y1) in
  let unit2 = get_unit (x2,y2) in
  let unit1_type = type_of unit1 in
  let unit2_type = type_of unit2 in
  if not (opposite_sides unit1 unit2) then print_string "units are allied, can't attack allies\n" else
  if get_endturn unit1 then print_string "turn is over, unit cannot attack\n" else
  if (not (in_range (x1,y1) (x2, y2) (get_total_range unit1)))
    then  print_string "unit out of range, can't attack\n" (* failwith "unit2 out of range of attack" *)
  else

    let (a,b) = attack unit1 unit2 in
    let () =
    if b = Null then
      ((if unit2_type = "Ally" then num_allies := !num_allies - 1
                             else num_enemies := !num_enemies - 1);
      !currentUnits.(y2).(x2) <- b; !currentUnits.(y1).(x1) <- a)
    else
    (*counterattack*)
      if (in_range (x2,y2) (x1, y1) (get_total_range unit2)) then
        let (c,d) = attack b a in
        (if d = Null then
                    if unit1_type = "Ally" then num_allies := !num_allies - 1
                                            else num_enemies := !num_enemies - 1
        else ());  !currentUnits.(y2).(x2) <- c; !currentUnits.(y1).(x1) <- d
      else ()
    in set_endturn unit1 true;num_usable_units := !num_usable_units-1


let move (x1,y1) (x2,y2) : unit =
  let u = get_unit (x1,y1) in
  let dest_terrain = match get_terrain (x2,y2) with
                     | Impassable _ -> "impassable"
                     | _ -> "other" in

  if get_endturn u then failwith "unit cannot move, turn is over" else
  if exists (x2,y2)
        then print_string "space is already occupied, can't move to it.\n" else
  if dest_terrain = "impassable"
         then print_string "destination is impassable, can't move to it.\n" else
  let path = shortest_path (x1,y1) (x2,y2) 10 (get_units ()) (get_map ()) in
  if List.length path.path > 0 then let terrain1 = get_terrain (x2,y2) in
              set_atk_bonus u (get_atkBonus terrain1);
              set_def_bonus u (get_defBonus terrain1);
              set_hasMoved u true;
              !currentUnits.(y1).(x1) <- Null;
              !currentUnits.(y2).(x2) <- u;

  else print_string "not a valid move, out of range of unit"



let wait (x,y) : unit =
  let u = get_unit (x,y) in
  let endturn = get_endturn u in
  if endturn then failwith "This unit's turn is over"
             else set_endturn u true; num_usable_units := !num_usable_units-1

let end_turns (): unit =
  let switch (a:feunit) :unit =
  match a with
      | Ally _ -> set_endturn a true; set_hasMoved a true
      | Enemy _ -> set_endturn a true; set_hasMoved a true
      | _ -> () in
  (Array.iter (fun a -> Array.iter (switch) a) !currentUnits);
  num_usable_units := 0
  (* let switch s (a:feunit) :unit =
  match s with
  | "Ally" -> let () =
              match a with
              | Ally _ -> set_endturn a true; set_hasMoved a true
              | _ -> ()
              in ()
  | "Enemy" -> let () = match a with
              | Enemy _ -> set_endturn a true; set_hasMoved a true
              | _ -> ()
              in ()
  | _ -> () in
  Array.iter (fun a -> Array.iter (switch s) a) !currentUnits *)

(*count allies*)
let count_allies (): int =
  let count = ref 0 in
  let () = for y = 0 to (Array.length !currentUnits)-1 do
                for x = 0 to (Array.length !currentUnits.(0))-1 do
                  match (!currentUnits.(y).(x)) with
                  | Ally _ -> incr count
                  | _ -> ()
                done
            done in
  !count

(*count enemies*)
let count_enemies (): int =
  let count = ref 0 in
  let () = for y = 0 to (Array.length !currentUnits)-1 do
                for x = 0 to (Array.length !currentUnits.(0))-1 do
                  match (!currentUnits.(y).(x)) with
                  | Enemy _ -> incr count
                  | _ -> ()
                done
            done in
  !count

(*starts start_turns for "Ally" or "Enemy"*)
let start_turns s :unit =
  let switch s (a:feunit) :unit =
  match s with
  | "Ally" -> let () =
              match a with
              | Ally _ -> set_endturn a false; set_hasMoved a false
              | _ -> ()
              in ()
  | "Enemy" -> let () = match a with
              | Enemy _ -> set_endturn a false; set_hasMoved a false
              | _ -> ()
              in ()
  | _ -> () in
  Array.iter (fun a -> Array.iter (switch s) a) !currentUnits


let set_units (feunits:feunit array array) : unit =
  currentUnits := feunits;
  turn := 1;
  num_allies := count_allies ();
  num_enemies := count_enemies ();
  num_usable_units := !num_allies;
  start_turns "Ally"

let set_map (map:terrain array array) : unit =
  currentTerrains := map;
  turn := 1



(* increments the turn counter *)
let inc_turn (): unit  = turn := !turn + 1

(* performs the actions list and updates the map and units based on the actions*)
let perform_actions (actions: action list) : unit =
  let perform_act action =
  match action with
  | Endturn -> end_turns ()
  | Wait (x,y) -> wait (x,y)
  | Move ((x1,y1),(x2,y2)) -> move (x1,y1) (x2,y2)
  | Attack ((x1,y1),(x2,y2)) -> attack_unit (x1,y1) (x2,y2) in
  List.iter perform_act actions

(*checks if the turn is over for "Ally" or "Enemy"*)
let turn_over s : bool =
  let check s (a:feunit) :bool =
  match s with
  | "Ally" -> let over =
              match a with
              |  Ally _ -> get_endturn a
              |  _ -> true
              in over
  | "Enemy" -> let over =
              match a with
              | Enemy _ -> get_endturn a
              | _ -> true
              in over
  | _ -> true in
  let check_array ary = Array.fold_left (fun a b -> a && check s b) true ary in
  Array.fold_left (fun a b -> a && check_array b) true !currentUnits

(* Goes through each terrain in currentTerrains and calls their draw functions *)
let draw_terrain () : unit =
  let (offX, offY) = InputManager.get_map_offset () in
  let minY = min (gameHeight/gridSide+offY) ((Array.length !currentTerrains)-1) in
  let minX = min (gameWidth/gridSide+offX) ((Array.length !currentTerrains.(0))-1) in
   for y = offY to minY do
      for x = offX to minX do
        Terrain.draw (!currentTerrains.(y).(x)) (x-offX,y-offY)
      done
  done

(* Goes through each unit in currentUnits and calls their draw functions *)
let draw_unit () : unit =
  let (offX, offY) = InputManager.get_map_offset () in
  let minY = min (gameHeight/gridSide+offY) ((Array.length !currentUnits)-1) in
  let minX = min (gameWidth/gridSide+offX) ((Array.length !currentUnits.(0))-1) in
  for y = offY to minY do
      for x = offX to minX do
        Feunit.draw (!currentUnits.(y).(x)) (x-offX,y-offY)
      done
  done

let draw () : unit =
  Graphics.auto_synchronize false;

  (* draw map objects first *)
  draw_terrain ();
  draw_unit ();

  (* for Player's cursor drawings *)
  Player.draw();

  (* for Hub drawings *)
  let (offX, offY) = InputManager.get_map_offset () in
  let cursor = Player.get_cursor () in
  let highlightedUnit = !currentUnits.(cursor.y+offY).(cursor.x+offX) in
  let highlightedTerrain = !currentTerrains.(cursor.y+offY).(cursor.x+offX) in
  Graphics.set_color Constants.textColor;
  Hub.draw_unit_stats highlightedUnit;
  Hub.draw_terrain_stats highlightedTerrain;
  Graphics.auto_synchronize true

let rec update () : int =
  (*if turn is odd it is Player's turn; if it is even it is enemy turn*)
  flush_all();

  if !num_enemies = 0 then (print_string "You win!\n\n";draw();1) else
  if !num_allies = 0 then (print_string "Enemies win. Try again.\n\n";draw();-1) else
  if !turn mod 2 = 1
  then
      player_turn ()
  else
      ai_turn ()

and player_turn ():int =
      if not (!num_usable_units = 0)
      then
        let actions = Player.update (get_units ()) (get_map ()) in
        perform_actions actions;
        if (!num_usable_units = 0) then
          (start_turns "Enemy";
          inc_turn ();
          num_usable_units := !num_enemies;
          draw ();
          Printf.printf "Turn %i: Enemy turn\n" !turn;
          update())
        else 0
      else 0

and ai_turn ():int =
      if not (!num_usable_units = 0)
      then
        let actions = Ai.update (get_units ()) (get_map ()) in
        perform_actions actions;
        draw ();
        if (!num_usable_units = 0) then
        (start_turns "Ally";
        inc_turn ();
        num_usable_units := !num_allies;
        Printf.printf "Turn %i: Player turn\n" !turn;
        draw ();
        update()
        )
        else
        (draw ();
        update())
      else
        0