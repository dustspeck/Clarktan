(* Elements module keeps useful informations used throughout the project *)

(* color is the type of different colors for different players *)
type color =
  | Red
  | Yellow
  | Blue
  | Green
  | White

(* [resource] represents a resource. *)
type resource =
  | Lumber
  | Wool
  | Grain
  | Brick
  | Ore
  | Null

(* [road] represents a road *)
type road = int * int

type port = {
  neighbors : int * int;
  resource : resource;
  rate : int
}
