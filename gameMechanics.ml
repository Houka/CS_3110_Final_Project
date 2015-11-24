open Terrain
open Feunit
open Constants
open PathFinder
open Player

let turn = ref 0
let currentUnits = ref [||]
let currentTerrains = ref [||]

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
  let u = get_unit (x1,y1) in
  if get_endturn u then failwith "unit cannot move, turn is over" else
  let path = shortest_path (x1,y1) (x2,y2) (get_units ()) (get_map ()) in
  if List.length path.path > 0 then let terrain1 = get_terrain (x2,y2) in
              set_atk_bonus u (get_atkBonus terrain1);
              set_def_bonus u (get_defBonus terrain1);
              set_hasMoved u true
  else failwith "not a valid move"


let wait (x,y) : unit =
  let u = get_unit (x,y) in
  let endturn = get_endturn u in
  if endturn then failwith "This unit's turn is over" else set_endturn u false

let end_turns (): unit =
  let switch (a:feunit) :unit =
  match a with
      | Ally _ -> set_endturn a true; set_hasMoved a true
      | Enemy _ -> set_endturn a true; set_hasMoved a true
      | _ -> () in
  Array.iter (fun a -> Array.iter (switch) a) !currentUnits
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

let set_units (feunits:feunit array array) : unit =
  currentUnits := feunits;
  turn := 0

let set_map (map:terrain array array) : unit =
  currentTerrains := map;
  turn := 0



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

(* Goes through each terrain in currentTerrains and calls their draw functions *)
let draw_terrain () : unit =
   for y = 0 to (Array.length !currentTerrains)-1 do
      for x = 0 to (Array.length !currentTerrains.(0))-1 do
        Terrain.draw (!currentTerrains.(y).(x)) (x,y)
      done
  done


(* Goes through each unit in currentUnits and calls their draw functions *)
let draw_unit () : unit =
  for y = 0 to (Array.length !currentUnits)-1 do
      for x = 0 to (Array.length !currentUnits.(0))-1 do
        Feunit.draw (!currentUnits.(y).(x)) (x,y)
      done
  done

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

let draw () : unit =
  (* draw map objects first *)
  draw_terrain ();
  draw_unit ();

  (* for Player's cursor drawings *)
  Player.draw()

  (* for Hub drawings *)(*
  let cursor = Player.get_cursor () in
  let highlightedUnit = !currentUnits.(cursor.y).(cursor.x) in
  let highlightedTerrain = !currentTerrains.(cursor.y).(cursor.x) in
  Hub.draw_unit_stats highlightedUnit;
  Hub.draw_terrain_stats highlightedTerrain *)

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

let rec update () : unit =
  if count_allies () = 0 then print_string "Enemies win.\n" else
  if count_enemies () = 0 then print_string "You win!\n" else
  (*if turn is even it is Player's turn; if it is odd it is enemy turn*)
  if !turn mod 2 = 1
  then
      if not (turn_over "Ally")
      then
        let actions = Player.update (get_units ()) (get_map ()) in
        perform_actions actions
      else
        (start_turns "Enemy";
        inc_turn ())
  else
      if not (turn_over "Enemy")
      then
        let actions = Ai.update (get_units ()) (get_map ()) in
        perform_actions actions;
        draw ();
        update()
      else
        start_turns "Ally";
        inc_turn ()
