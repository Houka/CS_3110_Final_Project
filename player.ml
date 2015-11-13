open Feunit
open Terrain

type cursor = {x: int; y: int; color: int}

let player_cursor = ref {x=0;y=0;color=0xFFFFFF}

(* finds player units to move*)
let find_player_units (units:feunit list) : feunit list = failwith "TODO"

let get_cursor () : cursor = !player_cursor

let draw () : unit = failwith "TODO"

let update (units :feunit list ref) (terrains: terrain list ref) : unit =
  failwith "TODO"



