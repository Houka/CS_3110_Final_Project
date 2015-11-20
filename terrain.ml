type stats = {name:string; atkBonus:int; defBonus:int; img: Images.t}

type terrain = Impassable | Sea of stats | Plain of stats
              | Mountain of stats | City of stats
              | Forest of stats

let get_terrain (classnum:int) : terrain = failwith "TODO"