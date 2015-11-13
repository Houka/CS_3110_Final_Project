open Graphics

(* GUI using Graphics *)

(* GUI variables *)
let width = 550
let height = 400
let scale = 2
let title = "OCaml Fire Emblem"

(* Variables that store info *)
let key_status = ref (false, ' ')

let update_key_status status =
  key_status := (status.keypressed, status.key)

(* Getter functions *)
let get_keypressed () = fst (!key_status)
let get_key () = snd(!key_status)

(* Main Game loop that updates all subsequent components *)
let rec update () =
  let input = wait_next_event [Button_down; Button_up; Key_pressed] in
  clear_graph ();
  match input.key with
  | 'q' ->  (* quit qui *)
            close_graph ()
  | x -> Printf.printf "Keypressed: %c\n" x;
          flush_all ();

          (* game and keyboard input updates *)
          update_key_status input;
          GameStateManager.update ();
          GameStateManager.draw ();
          update ()

(* Initializes the GUI and goes into main game loop *)
let main () =
  (* init gui window *)
  open_graph "";
  resize_window (width*scale) (height*scale);
  set_window_title title;

  (* enter main game loop *)
  update ()

(* Starts the whole game *)
let () = main ()