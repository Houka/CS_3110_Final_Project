open Graphics

let draw () =
  let random_color = Random.int 0xFFFFFF in
  set_color random_color;
  fill_rect 0 0 (size_x ()) (size_y ())

let update x = match x with
  | 'r' ->  (* random background change *)
            draw()
  | _ -> ()