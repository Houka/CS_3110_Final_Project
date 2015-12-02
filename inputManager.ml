
let keyPressed = ref (false, ' ')
let offset = ref (0,0)
let mapLimits = ref (0,0)

let set_keypressed (b: bool) (k: char) : unit = keyPressed := (b, k)
let get_keypressed (): bool = fst (!keyPressed)
let get_key (): char = snd (!keyPressed)

let get_map_offset () = !offset
let add_map_offset x y =
  let (x0,y0) = !offset in
  let (limX, limY) = !mapLimits in
  let x' = if x + x0 + Constants.(gameWidth/gridSide) <= limX
          then if x + x0 < 0 then 0 else x
          else 0 in
  let y' = if y + y0 + Constants.(gameHeight/gridSide) <= limY
          then if y + y0 < 0 then 0 else y
          else 0 in
  offset := (x'+x0,y'+y0)
let reset_map_offset () = offset:=(0,0)

let set_map_limits w h = mapLimits := (w,h)