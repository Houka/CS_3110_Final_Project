open Feunit
open Terrain

let draw_unit_stats (feunit : feunit) : unit = failwith "TODO"

let draw_terrain_stats (terrain: terrain) : unit = failwith "TODO"

let draw_level_stats (map: level) : unit  = failwith "TODO"

let draw_string (text: string) (x,y) : unit =
  Graphics.moveto x y;
  Graphics.fontGraphics.draw_string text