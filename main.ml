open Graphics

(* GUI using Graphics and CamlImages *)

let rec update () =
  let input = wait_next_event [Button_down; Button_up; Key_pressed; Mouse_motion] in
  clear_graph ();
  match input.key with
  | 'q' ->  (* quit qui *)
            close_graph ()
  | x -> Printf.printf "Keypressed: %c\n" x;
          flush_all ();
          Game.update x;
          update ()

let main () =
  (* init gui window *)
  open_graph "";
  resize_window 640 320;
  set_window_title "OCaml Fire Emblem";

  (* enter main game loop *)
  update ()

let () = main ()