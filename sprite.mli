(*
 * The Sprite Module.
 *   - Loads all image data from json on startup. Then stores it in a drawable
 *      format that Graphics can use to put in the GUI
 *   - Images stored in a (string*Images.t) list ref which is accessed to get img
 *)

(* [getImage filename] returns the image associated with the file named
 *  [filename].
 *  Precondition: [filename] points to a .png file
 *)
val getImage: string -> Images.t

(* [resize img w h] returns an altered image of [img] that has width [w] and
 *   height [h]
*)
val resize: Images.t -> int -> int -> Images.t

(* [scale img x] is the image [img] scaled to value x *)
val scale: Images.t -> int -> Images.t

(* [crop img (x,y) w h] returns an portion of [img] where ([x], [y]) is the
 *  starting coordinate relative to the bottom-left corner of [img] and
 *  [w] and [h] is the new image size. Its the basic definition of cropping.
 *)
val crop: Images.t -> (int*int) -> int -> int -> Images.t