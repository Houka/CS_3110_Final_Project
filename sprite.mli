(*
 * The Sprite Module.
 *   - Loads all image data from json on startup. Then stores it in a drawable
 *      format that Graphics can use to put in the GUI
 *   - Images stored in a (string*image) list ref which is accessed to get img
 *)

type image

(* initializes sprite by loading all needed images *)
val init: unit -> unit

(* [load_image filename] returns the image associated with the file named
 *  [filename].The difference between get_image and load_image is that get_image
 *  gets an image from a preload list of images but load_image has to convert
 *  a file into the type image
 *  Precondition: [filename] points to a .png file
 *)
val load_image: string -> image

(* [get_image filename] returns the image associated with the file named
 *  [filename]. The difference between get_image and load_image is that get_image
 *  gets an image from a preload list of images but load_image has to convert
 *  a file into the type image
 *  Precondition: [filename] points to a .png file
 *)
val get_image: string -> image

(* [resize img w h] returns an altered image of [img] that has width [w] and
 *   height [h]
*)
val resize: image -> int -> int -> image

(* [scale img x] is the image [img] scaled to value x *)
val scale: image -> float -> image

(* [crop img (x,y) w h] returns an portion of [img] where ([x], [y]) is the
 *  starting coordinate relative to the bottom-left corner of [img] and
 *  [w] and [h] is the new image size. Its the basic definition of cropping.
 *)
val crop: image -> (int*int) -> int -> int -> image

(* [draw img (x,y)] Draws the image onto the currently open GUI at coordinate (x,y).
 * Note: (0,0) is at the bottom left of the gui window
 * Prec : must have a Graphics gui open
 *)
val draw: image -> (int*int) -> unit