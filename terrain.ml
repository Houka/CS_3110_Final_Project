type stats = {name:string; atkBonus:int; defBonus:int; img: Images.t;
              x: int; y: int}

type terrain = Null | Sea of stats | Plain of stats
              | Mountain of stats | City of stats
              | Forest of stats

let get_terrain (classnum:int) (name: string) (x,y) : terrain = failwith "TODO"

let move_terrain (terrain: terrain) (x,y) : terrain = failwith "TODO"