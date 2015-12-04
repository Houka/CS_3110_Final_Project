open Graphics
open Constants

(* GUI using Graphics *)

(* Main Game loop that updates all subsequent components *)
let rec update input =
  match input.key with
  | 'q' ->  (* quit qui *)
            close_graph ()
  | x ->
          (* keyboard input updates *)
          InputManager.set_keypressed input.keypressed input.key;

          (* game updates *)
          GameStateManager.update ();
          flush_all ();
          (* Game draw *)
          Graphics.auto_synchronize false;
          Graphics.clear_graph();
          GameStateManager.draw ();
          Graphics.auto_synchronize true;
          update (wait_next_event [Button_down; Button_up; Key_pressed])


let init () =
  let input = wait_next_event [Button_down; Button_up; Key_pressed] in
  Graphics.clear_graph();
  (* enter main game loop *)
  update (input)

(* Initializes the GUI and goes into main game loop *)
let main () =
  (* init gui window *)
  open_graph "";
  resize_window (gameWidth*gameScale) (gameHeight*gameScale);
  set_window_title gameTitle;

  (* loading screen *)
  Sprite.(draw (resize (load_image "images/misc/loading.png") gameWidth gameHeight) (0,0));

  (* inits *)
  Sprite.init ();
  GameStateManager.set_level_data "tutorial";

  (* loaded screen *)
  Sprite.(draw (resize (load_image "images/misc/loaded.png") gameWidth gameHeight) (0,0));



  init()



(* Starts the whole game *)
let () =
  main ()