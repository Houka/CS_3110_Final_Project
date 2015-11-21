open Feunit
open Terrain
open Constants

type dest_path = {start: (int * int);
                  destination: (int * int);
                  mutable cost: int;
                  mutable path: (int * int) list}


(*Returns an element in a matrix given coordinate *)
let grab (matrix: 'a list list) ((i, j) : int * int) : 'a =
  List.nth (List.nth matrix i) j

(* finds units to move or attack, returns the index of enemy and ally feunit*)
let find_units (units: feunit list list) : ((int*int) list * (int*int) list) =
 let rec row (ulist : feunit list list) el al i l  =
   match ulist with
   | [] -> (el, al)
   | rh::rt -> let rec column rlist el1 al1 i l =
                 (match rlist with
                  | [] -> (el1, al1)
                  | hd::tl -> (match hd with
                              | Enemy s -> column tl ((i, l)::el1) al1 i (l + 1)
                              | Ally s -> column tl el1 ((i, l)::al1) i (l + 1)
                              | Null -> column tl el1 al1 i (l + 1)))
                in
                let (a, b) = column rh [] [] i 0 in
                row rt (a@el) (b@al) (i + 1) 0
  in row units [] [] 0 0

(*Returns a list of record that contains the shortest path from given enemy unit
to a player unit*)
let shortest_path (enemy: (int * int)) (ally: (int * int))
(units : feunit list list) (terrains : terrain list list) : dest_path =
  let d = {start = enemy; destination = ally; cost = max_int; path = []} in
  let is_valid (i, j) visited c =
    let efficient = c <= d.cost in
    let bounds = i < List.length units && i >= 0 &&
                 j < List.length (List.nth units 0) && j >= 0 in
    let retrace = List.fold_left (fun a x -> not (x = (i, j)) && a) true
                  visited in
    let unit_obstacle = if bounds then
                          (match (grab units (i, j)) with
                          | Null -> true
                          | _ -> if (i, j) = ally then true else false)
                        else false in
    let terrain_obstacle = if bounds then
                             (match (grab terrains (i, j)) with
                             | Sea _ | Mountain _| Impassable -> false
                             | _ -> true)
                           else false in
    (efficient && bounds && retrace && unit_obstacle && terrain_obstacle)
  in
  let rec find_path (i, j) visited c p =
    if (i, j) = ally then
      if c < d.cost then (d.cost <- c; d.path <- List.rev p) else ()
    else
      (*up*)
      if is_valid (i - 1, j) visited (c + 1) then
        find_path (i - 1, j) ((i, j)::visited) (c + 1) ((i - 1, j)::p)
      else ();
      (*right*)
      if is_valid (i, j + 1) visited (c + 1) then
        find_path (i, j + 1) ((i, j)::visited) (c + 1) ((i, j + 1)::p)
      else ();
      (*down*)
      if is_valid (i + 1, j) visited (c + 1) then
        find_path (i + 1, j) ((i, j)::visited) (c + 1) ((i + 1, j)::p)
      else ();
      (*left*)
      if is_valid (i, j - 1) visited (c + 1) then
        find_path (i, j - 1) ((i, j)::visited) (c + 1) ((i, j - 1)::p)
      else ();
  in (find_path enemy [] 0 []); d

(*Returns list of move action given an unit. Move action is limited by the given
  unit's movRange*)
let move (d: dest_path) (enemy: feunit) : action list =
  let path = d.path in
  let cost = d.cost in
  let rec loop p actions c =
    match p with
    | [] -> actions
    | (x,y)::tl ->
        if c > 0 then
          let m = Move (enemy, x, y) in
          loop tl (actions@[m]) (c - 1)
        else
          actions
  in loop path [] cost

(*Returns list of move action ending with an attack action. List of action is
  limited by given unit's movRange and atkRange*)
let move_attack (d: dest_path) (enemy: feunit) (target: feunit) : action list =
  let es = match enemy with | Enemy s | Ally s -> s | _ -> failwith "invalid" in
  let path = d.path in
  let attack = Attack (enemy, target) in
  let rec loop p actions =
    match p with
    | [] -> actions
    | (x1,y1)::(x2, y2)::[] ->
        if es.atkRange > 1 then
          actions@[attack]
        else
          let m = Move (enemy, x1, y1) in
          actions@[m; attack]
    | (x, y)::tl ->
        let m = Move (enemy, x, y) in
        loop tl (actions@[m])
  in loop path []

(*Returns list of unit/target that has the lowest health. If there are multiple
  units of lowest health, it returns all of those units*)
let find_lowest (units: feunit list list) (dl: dest_path list) : dest_path list =
  let lowest_hp = ref max_int in
  List.fold_left (
    fun a x ->
       let u = match (grab units x.destination) with
               | Enemy s | Ally s -> s | _ -> failwith "invalid" in
       if a = [] then
         (lowest_hp := u.hp; [x])
       else
         let hp = u.hp in
         if hp < !lowest_hp then
           (lowest_hp := hp; [x])
         else if hp = !lowest_hp then
           x::a
         else a
  ) [] dl


(*Returns list of unit/target that is the weakest. Returns only one unit*)
let find_effective (units: feunit list list) (weapon: string)
(dl: dest_path list) : dest_path =
  let fst_w = (List.nth dl 0) in
  List.fold_left (
    fun a x ->
       let w = match (grab units x.destination) with
               | Enemy s | Ally s -> s.weapon | _ -> failwith "invalid" in
       let aw = match (grab units a.destination) with
               | Enemy s | Ally s -> s.weapon | _ -> failwith "invalid" in
       if weapon = "sword" then
         if (w = "axe" || w = "sword" || w = "bow") &&
         (not (aw = "axe")) then
           x
         else if w = "lance" &&
         (not (aw = "sword" || aw = "axe" || aw = "bow")) then
           x
         else
           a
       else if weapon = "lance" then
         if (w = "sword" || w = "lance" || w = "bow") &&
         (not (aw = "sword")) then
           x
         else if w = "axe" &&
         (not (aw = "lance" || aw = "sword" || aw = "bow")) then
           x
         else
           a
       else if weapon = "axe" then
         if (w = "lance" || w = "axe" || w = "bow") &&
         (not (aw = "lance")) then
           x
         else if w = "sword" &&
         (not (aw = "lance" || aw = "axe" || aw = "bow")) then
           x
         else
           a
       else
           a
  ) fst_w dl

let update (units:feunit list list) (terrains: terrain list list)
: action list  =
  (*Finds the index of enemy and ally unit in units*)
  let (e, a) = find_units units in
  let enemies = e in
  let players = a in

  (*Loop through enemy feunit *)
  let rec create_action enemy =
    match enemy with
    | [] -> []
    | hd::tl ->
        let paths =
          List.map (fun x -> shortest_path hd x units terrains) players in
        let e = match (grab units hd) with
                | Enemy s | Ally s -> s | _ -> failwith "invalid" in
        let within =
          List.filter (fun d -> d.cost <= (e.atkRange + e.movRange)) paths in
        if List.length within > 1 then
          (*Check healths, if more than one target then finds most effectiveness*)
          let targets = find_lowest units within in
          if List.length targets > 1 then
            let weapon = match (grab units hd) with
                         | Enemy s | Ally s -> s.weapon
                         | _ -> failwith "invalid" in
            let target = find_effective units weapon targets in
            let actions = move_attack target (grab units hd)
                          (grab units target.destination) in
            actions@(create_action tl)
          else
            let actions =
              match targets with
              | [] -> []
              | dh::_ -> move_attack dh (grab units hd)
                         (grab units dh.destination)
            in
            actions@(create_action tl)
        else if List.length within = 1 then
          (*Atack closest Unit*)
          let actions =
            match paths with
            | [] -> []
            | dh::_ -> move_attack dh (grab units hd)
                       (grab units dh.destination)
          in
          actions@(create_action tl)
        else
          (*Move towards closest Unit*)
          let closest =
          List.fold_left (fun a x -> if x.cost < a.cost then x else a)
          (List.nth paths 0) paths in
          let actions = move closest (grab units hd) in
          actions@(create_action tl)
  in
  create_action enemies