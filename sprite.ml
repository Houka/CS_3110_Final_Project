type image = OImages.oimage

let load_image (filename:string) : image =
  let img = OImages.load filename [] in
  match OImages.tag img with
  |  OImages.Rgb24 x -> img
  | OImages.Rgba32 x -> let img = x#to_rgb24 in img#coerce
  | _ -> failwith "unsupported format"

(* loads all images into a mapping *)
let images =
  let imgs = Jsonparser.get_images () in
  List.fold_left (fun a x -> (x,load_image x) :: a) [] imgs


let get_image (filename: string) : image =
  List.assoc filename images

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