open Async.Std

type image = OImages.oimage

let images = ref (Ivar.create ())

let load_image (filename:string) : image =
  let img = Printf.printf "loaded image: %s\n" filename; OImages.load filename [] in
  match OImages.tag img with
  | OImages.Rgb24 x -> img
  | OImages.Rgba32 x -> let img = x#to_rgb24 in img#coerce
  | _ -> failwith "unsupported format"

let loaded () : bool =
  not (Ivar.is_empty !images)

let get_image (filename: string) : image =
  if loaded () then
    match Deferred.peek (Ivar.read !images) with
    | None -> failwith "Something went wrong in images"
    | Some e -> List.assoc filename e
  else
    failwith "No images loaded"

let resize (img: image) (width: int) (height: int) : image =
  let img = OImages.rgb24 img in
  let img = img#resize None width height in
  img#coerce

let scale (img: image) (s: float) : image =
  let width = float_of_int (img#width) in
  let height = float_of_int (img#height) in
  resize img (int_of_float(width *. s)) (int_of_float(height *. s))

let crop (img:image) (x,y) (height: int) (width: int) : image =
  OImages.sub img x y height width

let draw (img: image) (x,y) : unit =
  let img = img#image in
  Graphic_image.draw_image img x y;;

(* loads all images into a mapping *)
let init () =
  upon (
    return (
      let imgs = Jsonparser.get_images () in
      List.fold_left (fun a x -> (x,load_image x) :: a) [] imgs
    ))
    (fun a -> Ivar.fill !images a)