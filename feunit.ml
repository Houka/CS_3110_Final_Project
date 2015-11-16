type action = Stay | Move | Attack

type stats = { name: string; maxHp: int; actions: action list;
              atkPoints: int; defPoint: int; atkRange: int; movRange: int;
              hp: int; atkBonus: int; defBonus: int; atkRangeBonus: int;
              movRangeBonus: int; x: int; y: int; img: Images.t; endturn: bool }

type feunit = Null | Ally of stats | Enemy of stats

let get_unit (classnum: int)  (name:string) (x,y) : feunit =
  failwith "TODO"

let move_unit (feunit: feunit) (x,y) : feunit =
  failwith "TODO"

let add_atk_bonus (feunit:feunit) (bonus:int) : feunit = failwith "TODO"

let add_def_bonus (feunit:feunit) (bonus:int) : feunit = failwith "TODO"

let add_mov_bonus (feunit:feunit) (bonus:int) : feunit = failwith "TODO"

let add_range_bonus (feunit:feunit) (bonus:int) : feunit = failwith "TODO"

let add_hp (feunit:feunit) (bonus:int) : feunit = failwith "TODO"

let get_total_atk (feunit:feunit) :int = failwith "TODO"

let get_total_def (feunit:feunit) :int = failwith "TODO"

let get_total_mov (feunit:feunit) :int = failwith "TODO"

let get_total_range (feunit:feunit) :int = failwith "TODO"

let get_percent_hp (feunit:feunit) :int = failwith "TODO"
