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

(* returns string of int in the form "(+n)" if n > 0, "(-n)" if n <0, else ""*)
let bonus_to_string n =
  if n > 0 then
    " (+"^(string_of_int  n)^")"
  else if n <0 then
    " ("^(string_of_int  n)^")"
  else ""

let draw_unit_stats (feunit : feunit) : unit =
  let get_stats_strings (unit_stats: stats) =
      ["Name: "^(unit_stats.name);
      "HP: "^(string_of_int unit_stats.hp)^"/"^(string_of_int unit_stats.maxHp);
      "Atk: "^(string_of_int unit_stats.atk)^(bonus_to_string unit_stats.atkBonus);
      "Def: "^(string_of_int unit_stats.def)^(bonus_to_string unit_stats.defBonus);
      "Mov: "^(string_of_int unit_stats.movRange)^(bonus_to_string unit_stats.movRangeBonus);
      "Range: "^(string_of_int unit_stats.atkRange)^(bonus_to_string unit_stats.atkRangeBonus);
      "Weapon: "^(unit_stats.weapon)
      ] in
  let draw_stats (unit_stats : stats) (x,y) =
    let unitStatsList = get_stats_strings unit_stats in
    let (w,h) = Graphics.text_size ("h") in
    draw_loop unitStatsList (x,y-h)
  in
  match feunit with
  | Null -> ()
  | Ally stats ->
    let (longestW, longestH) = get_longest_string_dim (get_stats_strings stats) in
    Graphics.set_color 0xFFFFFF;
    Graphics.fill_rect 0 (Constants.gameHeight-100) (longestW+Constants.textPadding) 100;
    Graphics.set_color 0x333333;
    draw_stats stats (Constants.textPadding/2,Constants.gameHeight)
  | Enemy stats ->
    let (longestW, longestH) = get_longest_string_dim (get_stats_strings stats) in
    Graphics.set_color 0xFFFFFF;
    Graphics.fill_rect (Constants.gameWidth - (longestW+Constants.textPadding))
                        (Constants.gameHeight-100) (longestW+Constants.textPadding) 100;
    Graphics.set_color 0x333333;
    draw_stats stats
      (Constants.(gameWidth-textPadding/2) - longestW, Constants.gameHeight)

let draw_terrain_stats (terrain: terrain) : unit =
  let get_stats_strings (terrain_stats: t_stats) =
    ["Name: "^(terrain_stats.name);
    "Atk Bonus: "^(string_of_int terrain_stats.atkBonus);
    "Def Bonus: "^(string_of_int terrain_stats.defBonus)
    ] in
  let draw_stats (terrain_stats : t_stats) (x,y) =
    let terrainStatsList = get_stats_strings terrain_stats in
    draw_loop terrainStatsList (x,y)
  in
  match terrain with
  | Impassable _ -> ()
  | Sea stats | Plain stats | Mountain stats | City stats | Forest stats ->
    let terrainStatsList = get_stats_strings stats in
    let (longestW,longestH) = get_longest_string_dim terrainStatsList in
    let maxTextHeight = longestH*(List.length terrainStatsList) in
    Graphics.set_color 0xFFFFFF;
    Graphics.fill_rect (Constants.gameWidth - (longestW+Constants.textPadding))
                        0 (longestW+Constants.textPadding) 60;
    Graphics.set_color 0x333333;
    (draw_stats stats (Constants.(gameWidth - textPadding/2) - longestW ,maxTextHeight))

let draw_current_turn (turn: int) : unit =
  let (longestW,longestH) = get_longest_string_dim ["Your Turn";"Enemy's Turn"] in
  let maxTextHeight = longestH*(List.length ["Your Turn";"Enemy's Turn"]) in
  let pos = (Constants.textPadding/2,maxTextHeight) in
  Graphics.set_color 0xFFFFFF;
  Graphics.fill_rect 0 0 (longestW+Constants.textPadding) (Constants.gameHeight-100);
  Graphics.set_color 0x333333;

  if turn = 1 then draw_string "Your Turn" pos
  else draw_string "Enemy's Turn" pos







