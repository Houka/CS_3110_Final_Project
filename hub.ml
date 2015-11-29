open Feunit
open Terrain

let draw_string (text: string) (x,y) : unit =
  Graphics.moveto x y;
  Graphics.draw_string text

(* draws a list of strings onto the main screen given the init x and y location *)
let rec draw_loop slist (x,y) : unit =
  match slist with
  | [] -> ()
  | hd::tl ->
      let (w,h) = Graphics.text_size (hd) in
      let y' = y - h in
      draw_string (hd) (x,y); draw_loop tl (x,y')


let get_longest_string_dim (l:string list) : int*int =
  List.fold_left (fun a x ->
    let len = Graphics.text_size (x) in
    if len>a then len else a
  ) (0,0) l

let draw_unit_stats (feunit : feunit) : unit =
  let get_stats_strings (unit_stats: stats) =
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
  let draw_stats (unit_stats : stats) (x,y) =
    let unitStatsList = get_stats_strings unit_stats in
    draw_loop unitStatsList (x,y)
  in
  match feunit with
  | Null -> ()
  | Ally stats -> draw_stats stats (Constants.textPadding,Constants.gameHeight)
  | Enemy stats ->
    let (longestW, longestH) = get_longest_string_dim (get_stats_strings stats) in
    (draw_stats stats
      (Constants.(gameWidth-textPadding) - longestW,Constants.gameHeight))

let draw_terrain_stats (terrain: terrain) : unit =
  let get_stats_strings (terrain_stats: t_stats) =
    ["Name: "^(terrain_stats.name);
    "Attack Bonus: "^(string_of_int terrain_stats.atkBonus);
    "Defense Bonus: "^(string_of_int terrain_stats.defBonus)
    ] in
  let draw_stats (terrain_stats : t_stats) (x,y) =
    let terrainStatsList = get_stats_strings terrain_stats in
    draw_loop terrainStatsList (x,y)
  in
  match terrain with
  | Impassable -> ()
  | Sea stats | Plain stats | Mountain stats | City stats | Forest stats ->
    let terrainStatsList = get_stats_strings stats in
    let (longestW,longestH) = get_longest_string_dim terrainStatsList in
    let maxTextHeight = longestH*(List.length terrainStatsList) in
    (draw_stats stats (Constants.(gameWidth - textPadding) - longestW ,maxTextHeight))



