open Jsonparser

type stats = { name: string; maxHp: int;
              atk: int; def: int; atkRange: int; movRange: int;
              mutable hp: int; mutable atkBonus: int; mutable defBonus: int;
              mutable atkRangeBonus: int; mutable movRangeBonus: int;
              weapon: string; img: Sprite.image; mutable endturn: bool;
              mutable hasMoved : bool}

type feunit = Null | Ally of stats | Enemy of stats

let get_unit (classnum: int) : feunit =
  if classnum = 0 then Null else
    let unit_list = get_all_unit_data () in
    let info = List.assoc (abs classnum) unit_list in
    (* let image_name = if classnum > 0 then info.Jsonparser.img^"_ally"
                                    else info.Jsonparser.img^"_enemy" in *)

    let unit_stats = {name = info.Jsonparser.name; maxHp = info.Jsonparser.maxHp;
        atk = info.Jsonparser.atk; def = info.Jsonparser.def;
        atkRange = info.Jsonparser.atkRange; movRange = info.Jsonparser.movRange;
        hp = info.Jsonparser.maxHp; atkBonus = 0; defBonus = 0;
        atkRangeBonus = 0; movRangeBonus = 0; weapon = info.Jsonparser.weapon;
        img = Sprite.(resize (get_image info.Jsonparser.img) Constants.gridSide Constants.gridSide);
        endturn = true; hasMoved = true} in
    print_string "creating unit\n";
    if classnum > 0
    then Ally unit_stats
    else Enemy unit_stats


let set_atk_bonus (feunit:feunit) (bonus:int) : unit =
  match feunit with
  | Null -> ()
  | Ally stats
  | Enemy stats -> stats.atkBonus <- bonus

let set_def_bonus (feunit:feunit) (bonus:int) : unit =
  match feunit with
  | Null -> ()
  | Ally stats
  | Enemy stats -> stats.defBonus <- bonus

let set_mov_bonus (feunit:feunit) (bonus:int) : unit =
  match feunit with
  | Null -> ()
  | Ally stats
  | Enemy stats -> stats.movRangeBonus <- bonus

let set_range_bonus (feunit:feunit) (bonus:int) : unit =
  match feunit with
  | Null -> ()
  | Ally stats
  | Enemy stats -> stats.atkRangeBonus <- bonus

let set_endturn (feunit:feunit) (b:bool) : unit =
  match feunit with
  | Null -> ()
  | Ally stats -> Printf.printf "ally turn ended %b\n" b;stats.endturn <- b
  | Enemy stats -> Printf.printf "enemy turn ended %b\n" b;stats.endturn <- b

let set_hasMoved (feunit:feunit) (b:bool) : unit =
  match feunit with
  | Null -> ()
  | Ally stats -> Printf.printf "ally moved %b\n" b;stats.hasMoved<- b
  | Enemy stats -> Printf.printf "enemy moved %b\n" b;stats.hasMoved<- b

let add_hp (feunit:feunit) (bonus:int) : unit =
  match feunit with
  | Null -> ()
  | Ally stats
  | Enemy stats ->  stats.hp <- stats.hp + bonus

let get_total_atk (feunit:feunit) :int =
  match feunit with
  | Null -> 0
  | Ally stats
  | Enemy stats -> stats.atk + stats.atkBonus

let get_total_def (feunit:feunit) :int =
  match feunit with
  | Null -> 0
  | Ally stats
  | Enemy stats -> stats.def + stats.defBonus

let get_total_mov (feunit:feunit) :int =
  match feunit with
  | Null -> 0
  | Ally stats
  | Enemy stats -> stats.movRange + stats.movRangeBonus

let get_total_range (feunit:feunit) :int =
  match feunit with
  | Null -> 0
  | Ally stats
  | Enemy stats -> stats.atkRange + stats.atkRangeBonus

let get_percent_hp (feunit:feunit) :int =
   match feunit with
  | Null -> 0
  | Ally stats
  | Enemy stats ->
      let percent = int_of_float
              (100.0*.(float_of_int stats.hp) /. (float_of_int stats.maxHp)) in
      if percent<0 then 0 else percent


let get_hp (feunit:feunit) :int =
   match feunit with
  | Null -> 0
  | Ally stats
  | Enemy stats -> stats.hp

let get_weapon (feunit:feunit) :string =
  match feunit with
  | Null -> ""
  | Ally stats
  | Enemy stats -> stats.weapon

let get_endturn (feunit: feunit) : bool =
  match feunit with
  | Null -> false
  | Ally stats
  | Enemy stats -> stats.endturn

let get_hasMoved (feunit: feunit) : bool =
  match feunit with
  | Null -> false
  | Ally stats
  | Enemy stats -> stats.hasMoved

let draw u (x,y) : unit =
   match u with
  | Null -> ()
  | Ally stats
  | Enemy stats ->
    let img = stats.img in
    let x' = x*Constants.gridSide in
    let y' =
      (-y-1+Constants.(gameHeight/gridSide))*Constants.gridSide in
    Sprite.(draw img (x',y'));
    Graphics.set_color 0xFF0000;
    Graphics.draw_rect (x'+5) y' (Constants.gridSide-10) 5;
    Graphics.fill_rect (x'+5) y' ((Constants.gridSide-10)*(get_percent_hp u)/100) 5

let attack (unit1: feunit) (unit2:feunit) : feunit*feunit =
  (*weapon triangle*)
  let weapon_bonus (a:feunit) (b:feunit) : int =
    let w1 = get_weapon a in
    let w2 = get_weapon b in

    match w1,w2 with
    | "sword", "axe" -> 2
    | "sword", "lance" -> -2
    | "lance", "axe" -> -2
    | "lance", "sword" -> 2
    | "axe", "sword" -> -2
    | "axe", "lance" -> 2
    | _ -> 0 in

    let hp_difference = (get_total_atk unit1) - (get_total_def unit2) +
                        (weapon_bonus unit1 unit2) in

    let () =if hp_difference > 0 then (add_hp unit2 (-1*hp_difference))
                                  else () in
 (*    set_endturn unit1 true;
    set_hasMoved unit1 true; *)
    if get_hp unit2 <=0 then (unit1, Null) else (unit1,unit2)