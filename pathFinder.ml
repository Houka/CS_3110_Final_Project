open Constants
open Feunit
open Terrain

type dest_path = {start: (int * int);
                  destination: (int * int);
                  mutable cost: int;
                  mutable path: (int * int) list}

(*Returns an element in a matrix given coordinate *)
let grab (matrix: 'a matrix) ((x, y) : int * int) : 'a =
  List.nth (List.nth matrix y) x

(* finds units to move or attack, returns the index of enemy and ally feunit*)
let find_units (units: feunit matrix) : ((int*int) list * (int*int) list) =
 let rec row (ulist : feunit matrix) el al i l  =
   match ulist with
   | [] -> (el, al)
   | rh::rt -> let rec column rlist el1 al1 i l =
                 (match rlist with
                  | [] -> (el1, al1)
                  | hd::tl -> (match hd with
                              | Enemy s -> column tl ((i, l)::el1) al1 (i + 1) l
                              | Ally s -> column tl el1 ((i, l)::al1) (i + 1) l
                              | Null -> column tl el1 al1 (i + 1) l))
                in
                let (a, b) = column rh [] [] 0 l in
                row rt (a@el) (b@al) 0 (l + 1)
  in row units [] [] 0 0

(*Returns a list of record that contains the shortest path from given enemy unit
to a player unit*)
let shortest_path (enemy: (int * int)) (ally: (int * int))
(units : feunit matrix) (terrains : terrain matrix) : dest_path =
  let d = {start = enemy; destination = ally; cost = max_int; path = []} in
  let is_valid (i, j) visited c =
    let efficient = c <= d.cost in
    let bounds = j < List.length units && j >= 0 &&
                 i < List.length (List.nth units 0) && i >= 0 in
    let retrace = List.fold_left (fun a x -> not (x = (i, j)) && a) true
                  visited in
    let unit_obstacle = if bounds then
                          (match (grab units (i, j)) with
                          | Null -> true
                          | _ -> (i, j) = ally)
                        else false in
    let terrain_obstacle = if bounds then
                             (match (grab terrains (i, j)) with
                             | Sea _ | Mountain _ | Impassable _ -> false
                             | _ -> true)
                           else false in
    (efficient && bounds && retrace && unit_obstacle && terrain_obstacle)
  in
  let rec find_path (i, j) visited c p =
    if (i, j) = ally then
      if c < d.cost then (d.cost <- c; d.path <- List.rev p) else ()
    else
      (*Left*)
      if is_valid (i - 1, j) visited (c + 1) then
        find_path (i - 1, j) ((i, j)::visited) (c + 1) ((i - 1, j)::p)
      else ();
      (*Down*)
      if is_valid (i, j + 1) visited (c + 1) then
        find_path (i, j + 1) ((i, j)::visited) (c + 1) ((i, j + 1)::p)
      else ();
      (*Right*)
      if is_valid (i + 1, j) visited (c + 1) then
        find_path (i + 1, j) ((i, j)::visited) (c + 1) ((i + 1, j)::p)
      else ();
      (*Up*)
      if is_valid (i, j - 1) visited (c + 1) then
        find_path (i, j - 1) ((i, j)::visited) (c + 1) ((i, j - 1)::p)
      else ();
  in
  if is_valid ally [] 0 then
    (find_path enemy [] 0 []; d)
  else
    d

let find_paths (units : feunit matrix) (terrains: terrain matrix)
((x,y): (int * int)) : (int * int) list =
  let s = match grab units (x,y) with
          | Enemy s | Ally s -> s
          | _ -> failwith "invalid" in
  let top = if (y - s.movRange) < 0 then 0 else (y - s.movRange) in
  let bottom = if (y + s.movRange) >= (List.length units) - 1 then
                 (List.length units) - 1
               else
                 (y + s.movRange) in
  let right = if (y + s.movRange) >= (List.length (List.nth units 0)) then
                (List.length (List.nth units 0)) - 1
              else
                (x + s.movRange) in
  let left = if (x - s.movRange) < 0 then 0 else (x - s.movRange) in
  let rec loop1 (x1, y1) l1 =
    match (y1 >= top && y1 <= bottom) with
    | true -> let rec loop2 x2 l2 =
                match (x2 >= left && x2 <= right) with
                | true -> let path = shortest_path (x,y) (x2, y1) units terrains in
                          if path.cost = max_int || path.cost > s.movRange then
                            loop2 (x2 + 1) l2
                          else
                            loop2 (x2 + 1) ((x2,y1)::l2)
                | false -> l2
              in loop1 (x1, y1 + 1) l1@(loop2 x1 l1)
    | false -> l1
  in loop1 (left, top) []
