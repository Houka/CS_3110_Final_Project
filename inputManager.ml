
let key_pressed = ref (false, ' ')

let set_keypressed (b: bool) (k: char) : unit =
  key_pressed := (b, k)
let get_keypressed (): bool = fst (!key_pressed)
let get_key (): char = snd (!key_pressed)