open Feunit
open Terrain

type level = {name: string; unit_matrix: int list list;
              terrain_matrix: int list list}

let get_level (name:string) : level = failwith "TODO"

let get_unit_matrix (lvl:level) : int list list = failwith "TODO"

let get_terrain_matrix (lvl:level) : int list list = failwith "TODO"