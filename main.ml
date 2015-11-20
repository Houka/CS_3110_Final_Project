open Graphics

(* GUI using Graphics *)

(* GUI variables *)
let width = 550
let height = 400
let scale = 1
let title = "OCaml Fire Emblem"

(* Main Game loop that updates all subsequent components *)
let rec update () =
  if GameStateManager.loaded () then
    let input = wait_next_event [Button_down; Button_up; Key_pressed] in
    clear_graph();
    match input.key with
    | 'q' ->  (* quit qui *)
              close_graph ()
    | x -> Printf.printf "Keypressed: %c\n" x;
            flush_all ();
            (* keyboard input updates *)
            InputManager.set_keypressed input.keypressed input.key;

            (* game updates *)
            GameStateManager.update ();
            GameStateManager.draw ();
            update ()
  else
    print_string "loading...\n";
    update ()

(* Initializes the GUI and goes into main game loop *)
let main () =
  (* init gui window *)
  print_string "initializing gui\n";
  open_graph "";
  resize_window (width*scale) (height*scale);
  set_window_title title;

  (* loading screen *)
  print_string "adding loading screen\n";
  Sprite.(draw (resize (load_image "images/loading.png") width height) (0,0));

  (* inits *)
  print_string "loading in contents\n";
  Sprite.init ();
  GameStateManager.set_current_state "level1";

  (* loaded screen *)
  print_string "adding loaded screen\n";
  Sprite.(draw (resize (load_image "images/loaded.png") width height) (0,0));

  (* enter main game loop *)
  print_string "entering main loop\n";
  update ()

(* Starts the whole game *)
let () =
  main ()