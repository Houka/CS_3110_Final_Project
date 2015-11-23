
type image = OImages.oimage

let images = ref []

let load_image (filename:string) : image =
  let img = Printf.printf "loaded image: %s\n" filename; OImages.load filename [] in
  match OImages.tag img with
  | OImages.Rgb24 x -> img
  | OImages.Rgba32 x -> img
  | _ -> failwith "unsupported format"

let get_image (filename: string) : image =
  let rec search l =
  match l with
  | [] -> failwith "no image found"
  | h::t -> if fst h = filename then snd h else search t in
  search !images

let resize (img: image) (width: int) (height: int) : image =
  match OImages.tag img with
  | OImages.Rgb24 x -> let img = x#resize None width height in img#coerce
  | OImages.Rgba32 x -> let img = x#resize None width height in img#coerce
  | _ -> failwith "unsupported image format"

let scale (img: image) (s: float) : image =
  let width = float_of_int (img#width) in
  let height = float_of_int (img#height) in
  resize img (int_of_float(width *. s)) (int_of_float(height *. s))

let crop (img:image) (x,y) (height: int) (width: int) : image =
  OImages.sub img x y height width

let draw (img: image) (x,y) : unit =
  let img = img#image in
  match img with
  | Images.Rgb24 _ -> Graphic_image.draw_image img x y
  | Images.Rgba32 bitmap ->
    let w = bitmap.Rgba32.width in
    let h = bitmap.Rgba32.height in
    (* constructing a bitmap array from image. Note Images/Graphic_image does
     *   not support Rgba32, so this is my solution base off of their src code.
     *
     *   source: http://docs.camlcity.org/docs/godisrc/camlimages-2.2.tgz/camlimages-2.2/graphics/graphic_image.ml
     *)
    let img' =
      Array.init h (fun i ->
        Array.init w (fun j ->
          let {Color.color = {Color.r=r; g=g; b=b}; alpha=a} =
            Rgba32.unsafe_get bitmap j i in
          if a = 0
          then Graphics.transp
          else Graphics.rgb r g b
        )
      ) in
    let img'' = Graphics.make_image img' in
    Graphics.draw_image img'' x y
  | _ -> failwith "unsupported image format"

(* loads all images into a mapping *)
let init () =
  let imgs = Jsonparser.get_images () in
  images := List.map (fun a -> (a,load_image a)) imgs