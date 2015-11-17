open Feunit
open Terrain
open Level
open Yojson.Basic.Util

(*should be changed later to accept user input with the following code:
let json =
  let a = Array.to_list Sys.argv in
  let name = List.nth a 1 in*)
let json = Yojson.Basic.from_file "example.json"

type terrain_info = {name:string; atkBonus:int; defBonus: int;
                      terrain_type:string; img: string}

type feunit_info = { name: string; maxHp: int; actions: action list;
              atk: int; def: int; atkRange: int; movRange: int;
              hp: int; weapon: string; img: string }
let get_all_unit_data ()
  = failwith "TODO"


(*below are the functions used for getting terrain data*)
let extract_terrain () =
  [json]
  |> filter_member "terrain"
  |> flatten

let extract_terrain_names (): string list =
  extract_terrain ()
  |> filter_member "name"
  |> filter_string

let extract_terrain_classes (): int list =
  extract_terrain ()
  |> filter_member "class"
  |> filter_int

let extract_terrain_atkBonuses (): int list =
  extract_terrain ()
  |> filter_member "atkBonus"
  |> filter_int

let extract_terrain_defBonuses (): int list =
  extract_terrain ()
  |> filter_member "defBonus"
  |> filter_int

let extract_terrain_images (): string list =
  extract_terrain ()
  |> filter_member "img"
  |> filter_string

let extract_level_types (): string list =
  extract_terrain ()
  |> filter_member "type"
  |> filter_string

let get_all_terrain_data () =
  (* let names = extract_terrain_names() in
  let classes = extract_terrain_classes() in
  let atkBonus = extract_terrain_atkBonuses () in
  let defBonus = extract_terrain_defBonuses () in
  let images = extract_terrain_images() in
  let rec make_list a b c d e: (int*terrain) list=
  match a,b,c,d,e with
    | [], [], [], [], [] -> []
    | h1::t1, h2::t2, h3::t3, h4::t4, h5::t5 ->
      (h2,{name = h1; atkBonus = h3; defBonus = h4; img= h5})
              :: make_list t1 t2 t3 t4 t5
    | _ -> failwith "Invalid json"
  in make_list names classes atkBonus defBonus images *)
failwith "TODO"



(*below are the functions used for getting level data*)
let extract_level_names (): string list =
  [json]
  |> filter_member "levels"
  |> flatten
  |> filter_member "name"
  |> filter_string

let extract_level_units (): int list list list =
  [json]
  |> filter_member "levels"
  |> flatten
  |> filter_member "units_matrix"
  |> filter_list
  |> List.map filter_list
  |> List.map (List.map filter_int)

let extract_level_terrain (): int list list list =
  [json]
  |> filter_member "levels"
  |> flatten
  |> filter_member "terrain_matrix"
  |> filter_list
  |> List.map filter_list
  |> List.map (List.map filter_int)

let get_all_level_data (): level list =
  let names = extract_level_names() in
  let units = extract_level_units() in
  let terrain = extract_level_terrain() in
  let rec make_list a b c : level list=
  match a,b,c with
    | [], [], [] -> []
    | h1::t1, h2::t2, h3::t3 ->
      {name = h1; unit_matrix = h2; terrain_matrix = h3} :: make_list t1 t2 t3
    | _ -> failwith "Invalid json"
  in make_list names units terrain

(*the code below is used to check the level data is correct*)
(* let _ =
  let level_list = get_all_level_data () in
  let print_level l :unit=
    let print_matrix m =
      let rec print_list a =
        match a with
        | [] -> print_string "\n"
        | h::t -> print_int h; print_string " ";print_list t in
      List.iter print_list m; print_string "\n" in
    print_endline l.name;print_matrix l.unit_matrix; print_matrix l.terrain_matrix
  in List.iter print_level level_list *)