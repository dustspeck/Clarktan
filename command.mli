open Elements

(* Command module takes in player's command, either through mouse click
 * or terminal entry, and parses them accordingly. *)

(* command represents possible types of commands *)
type command =
  | Build of structure * float * float
  | Play of string
  | Move of float * float
  | Trade of (resource * int) list * (resource * int) list
  | Accept of bool
  | Discard of string
  | Look
  | EndTurn
  | Invalid
  | Quit
and structure = Settlement | City | Road

(* [parse str] parses the command given by [str] to type command *)
val parse_text : State.state -> string -> command
