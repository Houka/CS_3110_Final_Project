open Feunit
open Terrain
open Constants
open PathFinder

(*Returns a enemy unit and a list of player unit given unit matrix, returns
  (-1, -1) if enemy unit not found*)
let find_first_units (units: feunit matrix) : ((int*int) * (int*int) list) =
 let rec row (ulist : feunit matrix) el al i l  =
   match ulist with
   | [] -> (el, al)
   | rh::rt -> let rec column rlist el1 al1 i l =
                 (match rlist with
                  | [] -> (el1, al1)
                  | hd::tl -> (match hd with
                              | Enemy s -> if s.endturn then
                                             column tl el1 al1 (i + 1) l
                                           else
                                             column tl (i,l) al1 (i + 1) l
                              | Ally s -> column tl el1 ((i, l)::al1) (i + 1) l
                              | Null -> column tl el1 al1 (i + 1) l))
                in
                let (a, b) = column rh (-1,-1) [] 0 l in
                if not (a = (-1, -1)) then
                  row rt a (b@al) 0 (l + 1)
                else
                  row rt el (b@al) 0 (l + 1)
  in row units (-1,-1) [] 0 0


(*Returns list of move action given an unit. Move action is limited by the given
  unit's movRange*)
let move (d: dest_path) (enemy: feunit) : action list =
    let es = match enemy with | Enemy s | Ally s -> s
             | _ -> failwith "invalid" in
    let path = d.path in
    let rec loop p actions c =
      match p with
      | [] -> actions
      | (x,y)::tl ->
          if c >= (es.movRange - 1) then
            [Move (d.start, (x, y)); Wait (x, y)]
          else
            loop tl [Move (d.start, (x,y))] (c + 1)
    in loop path [] 0

(*Returns list of move action ending with an attack action. List of action is
  limited by given unit's movRange and atkRange*)
let move_attack (d: dest_path) (enemy: feunit) : action list =
  let es = match enemy with | Enemy s | Ally s -> s | _ -> failwith "invalid" in
  let path = d.path in
  let rec loop p actions =
    match p with
    | [] -> actions
    | (x1,y1)::(x2, y2)::(x3, y3)::[] ->
        if es.atkRange > 1 then
          let m = Move (d.start, (x1, y1)) in
          let a = Attack ((x1, y1), (x3, y3)) in
          [m;a]
        else
          let m = Move (d.start, (x2, y2)) in
          let a = Attack ((x2, y2), (x3, y3)) in
          [m;a]
    | (x1,y1)::(x2, y2)::[] ->
        if es.atkRange > 1 then
          let a = Attack (d.start, (x2, y2)) in
          [a]
        else
          let m = Move (d.start, (x1, y1)) in
          let a = Attack ((x1, y1), (x2, y2)) in
          [m;a]
    | (x, y)::[] ->
          let a = Attack (d.start, (x, y)) in
          [a]
    | (x, y)::tl ->
        loop tl actions
  in loop path []

(*Returns list of unit/target that has the lowest health. If there are multiple
  units of lowest health, it returns all of those units*)
let find_lowest (units: feunit matrix) (dl: dest_path list) : dest_path list =
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
let find_effective (units: feunit matrix) (weapon: string)
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

(* Checks whether or not a given destination is unreachable because it is
blocked by impassable or other units*)
let denied_paths (u: feunit) ((x,y): int*int) (dest: int*int) : bool =
  let s = match u with | Enemy s | Ally s -> s | _ -> failwith "No Unit" in
  let mov4 = [(0, 4); (1, 3); (0, 3); (-1, 3); (2, 2); (1, 2); (0, 2); (-1, 2);
              (-2, 2); (3, 1); (2, 1); (1, 1); (0, 1); (-1, 1); (-2, 1); (-3, 1);
              (3, 0); (2, 0); (1, 0); (-1, 0); (-2, 0); (-3, 0); (-4, 0); (3, -1);
              (2, -1); (1, -1); (0, -1); (-1, -1); (-2, -1); (-3, -1); (2, -2);
              (1, -2); (0, -2); (-1, -2); (-2, -2); (1, -3); (0, -3); (-1, -3);
              (0, -4)]
  in
  let mov5 = [(0, 5); (1, 4); (0, 4); (-1, 4); (2, 3); (1, 3); (0, 3); (-1, 3);
              (-2, 3);(3, 2); (2, 2); (1, 2); (0, 2); (-1, 2); (-2, 2); (-3, 2);
              (3, 1); (2, 1); (1, 1); (0, 1); (-1, 1); (-2, 1); (-3, 1); (-4, 1);
              (3, 0); (2, 0); (1, 0); (-1, 0); (-2, 0); (-3, 0); (-4, 0); (-5, 0);
              (3, -1); (2, -1); (1, -1); (0, -1); (-1, -1); (-2, -1); (-3, -1);
              (-4, -1); (3, -2); (2, -2); (1, -2); (0, -2); (-1, -2); (-2, -2);
              (-3, -2); (2, -3); (1, -3); (0, -3); (-1, -3); (-2, -3); (1, -4);
              (0, -4); (-1, -4); (0, -5)]
  in
  let mov6 = [(0, 6); (1, 5); (0, 5); (-1, 5); (2, 4); (1, 4); (0, 4); (-1, 4);
              (-2, 4); (3, 3); (2, 3); (1, 3); (0, 3); (-1, 3); (-2, 3); (-3, 3);
              (4, 2); (3, 2);(2, 2); (1, 2); (0, 2); (-1, 2); (-2, 2); (-3, 2);
              (-4, 2); (5, 1); (4, 1); (3, 1); (2, 1); (1, 1); (0, 1); (-1, 1);
              (-2, 1); (-3, 1); (-4, 1); (-5, 1); (6, 0); (5, 0); (4, 0); (3, 0);
              (2, 0); (1, 0); (-1, 0); (-2, 0); (-3, 0); (-4, 0); (-5, 0);
              (-6, 0); (5, -1); (4, -1); (3, -1); (2, -1); (1, -1); (0, -1);
              (-1, -1); (-2, -1); (-3, -1); (-4, -1); (-5, -1); (4, -2); (3, -2);
              (2, -2); (1, -2); (0, -2); (-1, -2); (-2, -2); (-3, -2); (-4, -2);
              (3, -3); (2, -3); (1, -3); (0, -3); (-1, -3); (-2, -3); (-3, -3);
              (2, -4); (1, -4); (0, -4); (-1, -4); (-2, -4); (1, -5); (0, -5);
              (-1, -5); (0, -6)]
  in
  match (s.movRange + s.atkRange) with
  | 4 ->
      let possible = List.map (fun (i,j) -> (x + i, y + j)) mov4 in
      List.mem dest possible
  | 5 ->
      let possible = List.map (fun (i,j) -> (x + i, y + j)) mov5 in
      List.mem dest possible
  | _ ->
      let possible = List.map (fun (i,j) -> (x + i, y + j)) mov6 in
      List.mem dest possible

(*Returns a list of action given a unit matrix and terrain matrix*)
let update (units:feunit matrix) (terrains: terrain matrix)
: action list  =
  let (enemy, a) = find_first_units units in
  if enemy = (-1, -1) then
    []
  else
    let players = a in
    let rec create_action enemy =
        let paths =
          List.map (fun x -> shortest_path enemy x 6 units terrains)
          players in
        let e = match (grab units enemy) with
                | Enemy s | Ally s -> s | _ -> failwith "invalid" in
        let within =
          List.filter (fun d -> (d.cost <= (e.atkRange + e.movRange)) &&
                       List.length d.path > 0) paths in
        if List.length within > 1 then
          let adj = List.filter (fun d -> d.cost = 1) paths in
          if List.length adj > 0 then
            let actions =
              match adj with
              | [] -> []
              | dh::_ -> move_attack dh (grab units enemy)
            in actions
          else
            let targets = find_lowest units within in
            if List.length targets > 1 then
              let weapon = match (grab units enemy) with
                           | Enemy s | Ally s -> s.weapon
                           | _ -> failwith "invalid" in
              let target = find_effective units weapon targets in
              let actions = move_attack target (grab units enemy) in
              actions
            else
              let actions =
                match targets with
                | [] -> []
                | dh::_ -> move_attack dh (grab units enemy)
              in
              actions
        else if List.length within = 1 then
          (*Atack closest Unit*)
          let actions =
            match within with
            | [] -> []
            | dh::_ -> move_attack dh (grab units enemy)
          in
          actions
        else
          let ignore =
            List.map (fun d -> d.destination)
            (List.filter (fun d -> denied_paths (grab units enemy)
                          enemy d.destination) paths) in
          let trim =
            List.fold_left (fun l c -> if List.mem c ignore then l else c::l)
            [] players in
          let (ex, ey) = match enemy with
                         | (x,y) -> (float_of_int x, float_of_int y) in
          let compare (x1, y1) (x2, y2) =
          match
            (sqrt((float_of_int x1 -. ex)**2. +. (float_of_int y1 -. ey)**2.),
            sqrt((float_of_int x2 -. ex)**2. +. (float_of_int y2 -. ey)**2.))
          with
          | (d1, d2) -> if d1 = d2 then 0 else if d1 > d2 then 1 else -1
          in
          let closest = List.sort compare trim in
          let rec move_closest c i =
            match c with
            | [] -> [Wait enemy]
            | hd::tl ->
                if i <= 0 then
                  [Wait enemy]
                else
                  let c_path = shortest_path enemy hd 15 units terrains in
                  if List.length c_path.path = 0 then
                    move_closest tl (i - 1)
                  else
                    move c_path (grab units enemy)
          in move_closest closest 4
    in
    create_action enemy