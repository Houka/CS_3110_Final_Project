open Terrain
open Feunit

let turn = ref 0
let currentUnits = [||]
let currentTerrains = [||]

(* contructs unit and terrain matrices that shows the position of the unit
    or terrain in the map
 *)
let construct_unit_matrix () =
  failwith "TODO"
let construct_terrain_matrix () =
  failwith "TODO"

(* legal actions *)
let attack (u1: feunit) (u2: feunit) : unit =
  failwith "TODO"
let move (u1: feunit) (x,y) : unit =
  failwith "TODO"
let wait (u1: feunit) : unit =
  failwith "TODO"

let draw () : unit =
  failwith "TODO"
let update (level, units, map) : unit =
  failwith "TODO"