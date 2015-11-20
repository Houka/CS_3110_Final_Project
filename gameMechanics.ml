open Terrain
open Feunit
open Async.Std

let turn = ref 0
let currentUnits = ref (Ivar.create ())
let currentTerrains = ref (Ivar.create ())


(* legal actions *)
let attack (u1: feunit) (u2: feunit) : unit =
  failwith "TODO"
let move (u1: feunit) (x,y) : unit =
  failwith "TODO"
let wait (u1: feunit) : unit =
  failwith "TODO"

let loaded () : bool =
  not (Ivar.is_empty !currentTerrains && Ivar.is_empty !currentUnits)

let set_units (feunits:feunit option array array) : unit =
  if Ivar.is_empty !currentUnits
  then Ivar.fill !currentUnits feunits
  else currentUnits := Ivar.create ();
      Ivar.fill !currentUnits feunits
let set_map (map:terrain option array array) : unit =
  if Ivar.is_empty !currentTerrains
  then Ivar.fill !currentTerrains map
  else currentTerrains := Ivar.create ();
      Ivar.fill !currentTerrains map

(* private getters *)
let get_units () : feunit option array array =
  match Deferred.peek (Ivar.read !currentUnits) with
  | None -> failwith "units not set"
  | Some e -> e
let get_terrains () : terrain option array array =
  match Deferred.peek (Ivar.read !currentTerrains) with
  | None -> failwith "units not set"
  | Some e -> e

let draw () : unit =
  failwith "TODO"
let update () : unit =
  failwith "TODO"