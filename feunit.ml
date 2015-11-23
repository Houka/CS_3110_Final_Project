open Jsonparser

type stats = { name: string; maxHp: int;
              atk: int; def: int; atkRange: int; movRange: int;
              mutable hp: int; mutable atkBonus: int; mutable defBonus: int;
              mutable atkRangeBonus: int; mutable movRangeBonus: int;
              weapon: string; img: Sprite.image; mutable endturn: bool }

type feunit = Null | Ally of stats | Enemy of stats

let get_unit (classnum: int) : feunit =
  if classnum = 0 then Null else
    let unit_list = get_all_unit_data () in
    let info = List.assoc (abs classnum) unit_list in

    let unit_stats = {name = info.Jsonparser.name; maxHp = info.Jsonparser.maxHp;
        atk = info.Jsonparser.atk; def = info.Jsonparser.def;
        atkRange = info.Jsonparser.atkRange; movRange = info.Jsonparser.movRange;
        hp = info.Jsonparser.maxHp; atkBonus = 0; defBonus = 0;
        atkRangeBonus = 0; movRangeBonus = 0; weapon = info.Jsonparser.weapon;
        img = Sprite.get_image info.Jsonparser.img; endturn = true} in
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
  | Ally stats
  | Enemy stats -> stats.endturn <- b

let add_hp (feunit:feunit) (bonus:int) : unit =
  match feunit with
  | Null -> ()
  | Ally stats
  | Enemy stats -> stats.hp <- stats.hp + bonus

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
      int_of_float ((float_of_int stats.hp) /. (float_of_int stats.maxHp))

let get_endturn (feunit: feunit) : bool =
  match feunit with
  | Null -> false
  | Ally stats
  | Enemy stats -> stats.endturn

let draw u (x,y) w h : unit =
   match u with
  | Null -> ()
  | Ally stats
  | Enemy stats ->
                  let img = stats.img in
                  Sprite.(draw (resize img w h) (x,y))