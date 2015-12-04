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

(* finds units to move sor attack, returns the index of enemy and ally feunit*)
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
let shortest_path (startc: (int * int)) (endc: (int * int)) (limit: int)
(units : feunit matrix) (terrains : terrain matrix) : dest_path =
  let d = {start = startc; destination = endc; cost = limit; path = []} in
  let is_valid (i, j) visited c =
    let efficient = c <= d.cost && c <= limit in
    let bounds = j < List.length units && j >= 0 &&
                 i < List.length (List.nth units 0) &&
                 i >= 0 &&
                 j < List.length terrains &&
                 i < List.length (List.nth terrains 0) in
    let retrace = List.fold_left (fun a x -> not (x = (i, j)) && a) true
                  visited in
    let unit_obstacle =
      let u = match grab units startc with
          | Enemy s | Ally s -> s
          | _ -> failwith "invalid" in
      let range1 = [(1,0); (0,1); (-1,0); (0,-1)] in
      let range2 = [(1,0); (0,1); (-1,0); (0,-1); (2,0); (0,2); (-2,0); (0,-2);
                    (1,1); (-1,-1); (1, -1); (-1,1)] in
      let last_move (x1,y1) (x2,y2) = (x1 + x2, y1 + y2) = endc in
      let passable (x,y) =
          let last =
            if u.atkRange = 1 then
              not (List.fold_left (fun b m -> b || last_move (x,y) m) false
              range1)
            else
              not (List.fold_left (fun b m -> b || last_move (x,y) m) false
              range2)
          in
          last && c < u.movRange - 2
      in
      if bounds then
        (match grab units (i, j) with
        | Null -> true
        | Ally _ -> (i, j) = endc || (match grab units (startc) with
                                      | Ally _ -> true
                                      | _ -> false)
        | Enemy _ -> (i, j) = endc || (match grab units (startc) with
                                      | Enemy _ -> passable (i, j)
                                      | _ -> false))
      else false
    in
    let terrain_obstacle = if bounds then
                             (match (grab terrains (i, j)) with
                             | Impassable _ -> false
                             | _ -> true)
                           else false in
    (efficient && bounds && retrace && unit_obstacle && terrain_obstacle)
  in
  let rec find_path (i, j) visited c p =
    if (i, j) = endc then
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
  if is_valid endc [] 0 then
    (find_path startc [] 0 []; d)
  else
    d

(*Returns a list of avalible relative coordinate that can be traveled by a
  a given unit*)
let find_paths (units : feunit matrix) (terrains: terrain matrix)
((x,y): (int * int)) : (int * int) list =
  let obstruction (i,j) =
    match grab units (i, j) with
    | Ally _ -> true
    | Enemy _ -> true
    | _ -> false in
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
                | true -> let path = shortest_path (x,y) (x2, y1)
                          (s.movRange + 1) units terrains in
                          if path.cost = (s.movRange + 1) || path.cost > s.movRange
                          || obstruction (x2,y1) then
                            loop2 (x2 + 1) l2
                          else
                            if (x2, y1) = (x, y) then
                              loop2 (x2 + 1) l2
                            else
                              loop2 (x2 + 1) ((x2,y1)::l2)
                | false -> l2
              in loop1 (x1, y1 + 1) l1@(loop2 x1 l1)
    | false -> l1
  in loop1 (left, top) []

(*Returns a list of avalible relative coordinate which can be attacked by a
  given unit*)
let find_attack (units : feunit matrix) (terrains: terrain matrix)
((x,y): (int * int)) : (int * int) list =
  let s = match grab units (x,y) with
          | Enemy s | Ally s -> s
          | _ -> failwith "invalid" in
  let is_valid (i,j) =
    let bounds = j < List.length units && j >= 0 &&
                 i < List.length (List.nth units 0) &&
                 i >= 0 &&
                 j < List.length terrains &&
                 i < List.length (List.nth terrains 0) in
    let terrain_obstacle = if bounds then
                             (match (grab terrains (i, j)) with
                             | Impassable _ -> false
                             | _ -> true)
                           else false in
    (bounds && terrain_obstacle)
  in
  let range1 = [(1,0); (0,1); (-1,0); (0,-1)] in
  let range2 = [(1,0); (0,1); (-1,0); (0,-1); (2,0); (0,2); (-2,0); (0,-2);
                (1,1); (-1,-1); (1, -1); (-1,1)] in
  let init_range = if s.atkRange = 1 then
                     List.map (fun (rx,ry) -> (x + rx, y + ry)) range1
                   else
                     List.map (fun (rx,ry) -> (x + rx, y + ry)) range2
  in
  List.filter (is_valid) init_range