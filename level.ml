open Jsonparser


type level = {name: string; unit_matrix: int list list;
              terrain_matrix: int list list; next:string}

let level_list = Jsonparser.get_all_level_data()

let level_info_to_list (info: Jsonparser.level_info) : level =
  {name = info.Jsonparser.name; unit_matrix = info.Jsonparser.unit_matrix;
  terrain_matrix = info.Jsonparser.terrain_matrix; next = info.Jsonparser.next}

let get_level (name:string) : level =
(*   let rec helper (l:level_info list):level_info =
  match l with
  | [] -> failwith "not found"
  | h::t -> if h.name = name then h else helper t in *)

  level_info_to_list (List.assoc name level_list)

let get_unit_matrix (lvl:level) : int list list = lvl.unit_matrix

let get_terrain_matrix (lvl:level) : int list list =  lvl.terrain_matrix