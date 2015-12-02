open Feunit
open Terrain

(* Draw a string onto the main screen given the x and y location *)
let draw_string (text : string) (x,y) : unit =
  Graphics.moveto x y;
  Graphics.draw_string text

(* Draw a list of strings onto the main screen given the x and y location *)
let rec draw_loop (slist : string list) (x,y) : unit =
  match slist with
  | [] -> ()
  | hd::tl ->
    (let (w,h) = Graphics.text_size (hd) in
    draw_string (hd) (x,y); draw_loop tl (x,y - h))

(* Get width and length of longest string in string list *)
let get_longest_string_dim (l:string list) : int*int =
  List.fold_left (fun a x ->
    let len = Graphics.text_size x in
    if len > a then len else a
  ) (0,0) l

(* Return string of int in the form "(+n)" if n > 0, "(-n)" if n < 0, else "" *)
let bonus_to_string n =
  if n > 0 then
    " (+"^(string_of_int  n)^")"
  else if n < 0 then
    " ("^(string_of_int  n)^")"
  else ""

(* Draw stats of highlighted unit *)
let draw_unit_stats (feunit : feunit) : unit =
  let get_stats_strings (unit_stats : stats) =
      ["Name: "^(unit_stats.name);
      "HP: "^(string_of_int unit_stats.hp)^"/"^(string_of_int unit_stats.maxHp);
      "Atk: "^(string_of_int unit_stats.atk)
             ^(bonus_to_string unit_stats.atkBonus);
      "Def: "^(string_of_int unit_stats.def)
             ^(bonus_to_string unit_stats.defBonus);
      "Mov: "^(string_of_int unit_stats.movRange)
             ^(bonus_to_string unit_stats.movRangeBonus);
      "Range: "^(string_of_int unit_stats.atkRange)
               ^(bonus_to_string unit_stats.atkRangeBonus);
      "Weapon: "^(unit_stats.weapon)
      ] in
  let draw_stats (unit_stats : stats) (x,y) =
    let unitStatsList = get_stats_strings unit_stats in
    let (w,h) = Graphics.text_size ("h") in
    draw_loop unitStatsList (x,y-h)
  in

  let padding = Constants.textPadding in

  match feunit with
  | Null -> ()
  | Ally stats ->
    (let (longestW, longestH) =
      get_longest_string_dim (get_stats_strings stats) in
    Graphics.set_color 0xFFFFFF;
    Graphics.fill_rect 0 (Constants.gameHeight - 100) (longestW + padding) 100;
    Graphics.set_color Graphics.blue;
    draw_stats stats (padding / 2,Constants.gameHeight);
    Graphics.set_color 0x333333)
  | Enemy stats ->
    (let (longestW, longestH) =
      get_longest_string_dim (get_stats_strings stats) in
    Graphics.set_color 0xFFFFFF;
    Graphics.fill_rect (Constants.gameWidth - (longestW + padding))
                       (Constants.gameHeight-100) (longestW + padding) 100;
    Graphics.set_color Graphics.red;
    draw_stats stats
      (Constants.(gameWidth - textPadding/2) - longestW, Constants.gameHeight);
    Graphics.set_color 0x333333)

(* Draw stats of highlighted terrain *)
let draw_terrain_stats (terrain : terrain) : unit =
  let get_stats_strings (terrain_stats : t_stats) =
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
    (let terrainStatsList = get_stats_strings stats in
    let (longestW,longestH) = get_longest_string_dim terrainStatsList in
    let maxTextHeight = longestH*(List.length terrainStatsList) in
    Graphics.set_color 0xFFFFFF;
    Graphics.fill_rect (Constants.gameWidth - (longestW+Constants.textPadding))
                       0 (longestW+Constants.textPadding) 60;
    Graphics.set_color 0x006400;
    (draw_stats stats
      (Constants.(gameWidth - textPadding/2) - longestW ,maxTextHeight));
    Graphics.set_color 0x333333)

(* Draw status of current turn (Your Turn or Enemy Turn) *)
let draw_current_turn (turn: int) : unit =
  let textList = ["Your Turn";"Enemy's Turn"] in
  let (longestW,longestH) = get_longest_string_dim textList in
  let maxTextHeight = longestH*(List.length textList) in
  let pos = (Constants.textPadding/2,maxTextHeight/2) in
  Graphics.set_color 0xFFFFFF;
  Graphics.fill_rect 0 0 (longestW+Constants.textPadding) 40;

  if (turn mod 2) = 1 then
    (Graphics.set_color Graphics.blue;
    draw_string "Your Turn" pos;
    Graphics.set_color 0x333333)
  else
    (Graphics.set_color Graphics.red;
    draw_string "Enemy's Turn" pos;
    Graphics.set_color 0x333333)







