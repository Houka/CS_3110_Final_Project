open Feunit
open Terrain

let draw_string (text: string) (x,y) : unit =
  Graphics.moveto x y;
  Graphics.draw_string text

let draw_unit_stats (feunit : feunit) : unit =
  let draw_stats (unit_stats : Feunit.stats) (x,y) =
    let unit_stats_list =
      ["Name: "^(unit_stats.name);
      "Attack: "^(string_of_int unit_stats.atk);
      "Defense: "^(string_of_int unit_stats.def);
      "Attack Range: "^(string_of_int unit_stats.atkRange);
      "Move Range: "^(string_of_int unit_stats.movRange);
      "HP: "^(string_of_int unit_stats.hp);
      "Max HP: "^(string_of_int unit_stats.maxHp);
      "Attack Bonus: "^(string_of_int unit_stats.atkBonus);
      "Defense Bonus: "^(string_of_int unit_stats.defBonus);
      "Attack Range Bonus: "^(string_of_int unit_stats.atkRangeBonus);
      "Move Range Bonus: "^(string_of_int unit_stats.movRangeBonus);
      "Weapon: "^(unit_stats.weapon)
      ] in

    let rec draw_loop slist (x,y) : unit =
      let y' = y - 1 in
      match slist with
      | [] -> ()
      | hd::tl -> draw_string (hd^"\n") (x,y); draw_loop tl (x,y')
    in draw_loop unit_stats_list (x,y)
  in
  match feunit with
  | Null -> ()
  | Ally stats -> draw_stats stats (0,Constants.gameHeight)
  | Enemy stats ->
    (draw_stats stats
      (Constants.gameWidth - Constants.gridSide,Constants.gameHeight))

let draw_terrain_stats (terrain: terrain) : unit =
  let draw_stats (terrain_stats : Terrain.stats) (x,y) =
    let terrain_stats_list =
      ["Name: "^(terrain_stats.name);
      "Attack Bonus: "^(string_of_int terrain_stats.atkBonus);
      "Defense Bonus: "^(string_of_int terrain_stats.defBonus)
      ] in
    let rec draw_loop slist (x,y) =
      let y' = y + 1 in
      match slist with
      | [] -> ()
      | hd::tl -> draw_string (hd^"\n") (x,y); draw_loop tl (x,y')
    in draw_loop terrain_stats_list (x,y)
  in
  match terrain with
  | Impassable -> ()
  | Sea stats | Plain stats | Mountain stats | City stats | Forest stats ->
    (draw_stats stats (Constants.gameWidth - Constants.gridSide,0))



