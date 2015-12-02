open Constants
open Yojson.Basic.Util

let json =
  let a = Array.to_list Sys.argv in
  let name = List.nth a 1 in
  Yojson.Basic.from_file name

type terrain_info = {name:string; atkBonus:int; defBonus: int;
                      terrain_type:string; img: string}

type feunit_info = { name: string; maxHp: int; atk: int; def: int;
                    movRange: int; atkRange: int; weapon: string; img: string }

type level_info = {name: string; unit_matrix: int matrix;
              terrain_matrix: int matrix; next:string}

(*in this section the functions are used for getting unit data*)

let extract_unit () =
  [json]
  |> filter_member "units"
  |> flatten

let extract_unit_name ():string list =
  extract_unit()
  |> filter_member "name"
  |> filter_string

let extract_unit_class ():int list  =
  extract_unit()
  |> filter_member "class"
  |> filter_int

let extract_unit_maxhp () :int list =
  extract_unit()
  |> filter_member "maxhp"
  |> filter_int

let extract_unit_attack (): int list =
  extract_unit()
  |> filter_member "attack"
  |> filter_int

let extract_unit_defense (): int list =
  extract_unit()
  |> filter_member "defense"
  |> filter_int

let extract_unit_move (): int list =
  extract_unit()
  |> filter_member "move"
  |> filter_int

let extract_unit_range (): int list =
  extract_unit()
  |> filter_member "range"
  |> filter_int

let extract_unit_weapon (): string list =
  extract_unit()
  |> filter_member "weapon"
  |> filter_string

let extract_unit_image ():string list =
  extract_unit()
  |> filter_member "image"
  |> filter_string


let get_all_unit_data (): (int*feunit_info) list =
  let names = extract_unit_name () in
  let classes = extract_unit_class () in
  let maxhp = extract_unit_maxhp () in
  let attack = extract_unit_attack () in
  let defense = extract_unit_defense () in
  let move = extract_unit_move () in
  let ranges = extract_unit_range () in
  let weapons = extract_unit_weapon () in
  let images = extract_unit_image () in

  let rec make_list a b c d e f g h i: (int*feunit_info) list=
  match a,b,c,d,e,f,g,h,i with
    | [], [], [], [], [], [], [], [], [] -> []
    | h1::t1, h2::t2, h3::t3, h4::t4, h5::t5, h6::t6, h7::t7, h8::t8, h9::t9->
      (h2,{name = h1; maxHp = h3; atk = h4; def= h5; movRange = h6;
        atkRange= h7; weapon = h8; img = h9})
              :: make_list t1 t2 t3 t4 t5 t6 t7 t8 t9
    | _ -> failwith "Invalid json"
  in make_list names classes maxhp attack defense move ranges weapons images

(* TEST_UNIT = let data = get_all_unit_data () in
            assert (data =
              [(0, {name = "null"; maxHp = 9999; atk = 0 ;
              def = 0; movRange = 1; atkRange = 0; weapon = "null";
              img = "null.png"});
            (1, {name = "swordsman"; maxHp = 100; atk = 5 ;
              def = 10; movRange = 3; atkRange = 1; weapon = "sword";
              img = "swordsman.png"})] ) *)



(*in this section are the functions used for getting terrain data*)
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

let get_all_terrain_data () : (int*terrain_info) list=
  let names = extract_terrain_names() in
  let classes = extract_terrain_classes() in
  let atkBonus = extract_terrain_atkBonuses () in
  let defBonus = extract_terrain_defBonuses () in
  let images = extract_terrain_images() in
  let types = extract_level_types() in
  let rec make_list a b c d e f: (int*terrain_info) list=
  match a,b,c,d,e,f with
    | [], [], [], [], [], [] -> []
    | h1::t1, h2::t2, h3::t3, h4::t4, h5::t5, h6::t6->
      (h2,{name = h1; atkBonus = h3; defBonus = h4; img= h5; terrain_type = h6})
              :: make_list t1 t2 t3 t4 t5 t6
    | _ -> failwith "Invalid json"
  in make_list names classes atkBonus defBonus images types

(*test getting terrain from examples.json*)
(* TEST_UNIT = let data = get_all_terrain_data () in
        assert (data = [(1, {name = "grass"; atkBonus = 1; defBonus = 1;
                            img = "grass.jpg"; terrain_type = "plain"})]) *)


(*below are the functions used for getting level data*)
let extract_level_names (): string list =
  [json]
  |> filter_member "levels"
  |> flatten
  |> filter_member "name"
  |> filter_string

let extract_level_units (): int matrix list =
  [json]
  |> filter_member "levels"
  |> flatten
  |> filter_member "units_matrix"
  |> filter_list
  |> List.map filter_list
  |> List.map (List.map filter_int)

let extract_level_terrain (): int matrix list =
  [json]
  |> filter_member "levels"
  |> flatten
  |> filter_member "terrain_matrix"
  |> filter_list
  |> List.map filter_list
  |> List.map (List.map filter_int)

let extract_level_next (): string list =
  [json]
  |> filter_member "levels"
  |> flatten
  |> filter_member "next"
  |> filter_string

let get_all_level_data (): (string*level_info) list =
  let names = extract_level_names() in
  let units = extract_level_units() in
  let terrain = extract_level_terrain() in
  let next = extract_level_next () in
  let rec make_list a b c d : (string*level_info) list=
  match a,b,c,d with
    | [], [], [], [] -> []
    | h1::t1, h2::t2, h3::t3, h4::t4->
      (h1,{name = h1; unit_matrix = h2; terrain_matrix = h3;next = h4})
       :: make_list t1 t2 t3 t4
    | _ -> failwith "Invalid json"
  in make_list names units terrain next

let get_images () : string list =
  let terrain_images = extract_terrain_images () in
  let unit_images = extract_unit_image () in
  let ally_images =
      List.map (fun x -> "images/sprites/allies/"^x) unit_images in
  let enemy_images =
      List.map (fun x -> "images/sprites/enemies/"^x) unit_images in
  terrain_images@ally_images@enemy_images



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