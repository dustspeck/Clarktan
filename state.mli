open Elements
open Player
open Command

(*****************************************************************************
 *                                DEFINITIONS                                *
 *****************************************************************************)

(* representation type for canvas background *)
type canvas = {
  tiles : Tile.tile list;
  ports : port list
}

(* state represents the game state type *)
type state = {
  robber : int;
  deck : DevCard.devcard list;
  turn : color;
  players : Player.player list;
  canvas : canvas
}

(*****************************************************************************
 *                               INITIAL PHASE                               *
 *****************************************************************************)

(* [init_canvas] returns a new canvas to be used in a new game *)
val init_canvas : unit -> canvas

(* [init_state ()] initializes the state type for the game by setting up the
 * canvas, which includes tiles and ports, and other relevant fields *)
val init_state : unit -> state

(* [init_build_settlement ind color st] changes the state when player
 * with color [color] at state [st] builds a settlement at index [ind]
 * raises: Failure "Cannot build settlement at this place" if the player's
 * chosen spot cannot have a settlement build *)
val init_build_settlement : int -> color -> state -> state

(* [init_build_road road color st] changes the state when player
 * with color [color] at state [st] builds a road at index [road]
 * raises : Failure "Cannot build road at this place" if the player's
 * chosen spot cannot have a road build *)
val init_build_road : road -> color -> state -> state

(* [init_generate_resources color st] changes the state when in the initial
 * phase the player with color [color] gets the auto-generated resources
 * after building initial settlements and roads at state [st] *)
val init_generate_resources : color -> state -> state

(*****************************************************************************
 *                                   BUILD                                   *
 *****************************************************************************)

(* returns: whether a settlement can be build at given index [ind]
 * for player with color [color] under state [st]
 * check: 1. whether player's number of settlements < 5
          2. resource is enough [1 lumber, 1 brick, 1 ore, i wool]
          3. whether check_build_settlements returns true
 * raises: Failure with specific message when settlement cannot be build
 * at given index *)
val can_build_settlement : int -> state -> color -> bool

(* returns: whether a road can be build at given index [ind]
 * for player with color [color] under state [st]
 * check: 1. whether players number of roads < 15
          2. resource is enough [1 lumber, 1 brick]
          3. whether check_build_road returns true
 * raises: Failure with specific message when road cannot be build at
 * given index *)
val can_build_road : road -> state -> color -> bool

(* returns: whether a city can be build at given index [ind]
 * for player with color [color] under state [st]
 * check: 1. whether players number of cities < 4
          2. resource is enough [3 grains, 2 ores]
          3. whether check_build_cities returns true
 * raises: Failure with specific message when city cannot be build at
 * given index *)
val can_build_city : int -> state -> color -> bool

(* [build_settlement ind st col] returns the new state after player with color
 * [col] at state [st] builds a new settlement at index [ind].
 * raises: Failure with message relevant to the error of player when settlement
 * cannot be build at the chosen index *)
val build_settlement : int -> state -> state

(* [build_road road st col] returns the new state after player with color
 * [col] at state [st] builds a new road at index [road].
 * raises: Failure with message relevant to the error of player when road
 * cannot be build at the chosen index *)
val build_road : road -> state -> state

(* [build_city ind st col] returns the new state after player with color
 * [col] at state [st] builds a new city at index [ind].
 * raises: Failure with message relevant to the error of player when city
 * cannot be build at the chosen index *)
val build_city : int -> state -> state

(* [buy_devcard col st] updates the state [st] when player with color
 * [col] buys a development card using resources.
 * raises: Failure with specific messages when resource card cannot be
 * bought at the time *)
val buy_devcard : state -> state

(*****************************************************************************
 *                                   TRADE                                   *
 *****************************************************************************)

(* [trade_with_player st l1 l2 col st] updates the state when player at
 * state [st] trades with bank.
 * raises: Failure when player cannot have a valid trade *)
val trade_with_bank :
  state -> (resource * int) list -> (resource * int) list -> color -> state

(* [trade_with_port st l1 l2 col st] updates the state when player at
 * state [st] trades with port.
 * raises: Failure when player cannot have a valid trade *)
val trade_with_port :
  state -> (resource * int) list -> (resource * int) list -> color -> state

(* [trade_with_player st l1 l2 col st] updates the state when player at
 * state [st] trades with another player.
 * raises: Failure when player cannot have a valid trade *)
val trade_with_player :
  state -> (resource * int) list -> (resource * int) list -> color -> state

(*****************************************************************************
 *                          PLAY A DEVELOPMENT CARD                          *
 *****************************************************************************)

(* [play_robber st] returns the new state after the player plays the
 * robber by dice 7 *)
val play_robber : state -> int -> state

(* [play_knight st col ind] updates the state [st] when player with color
 * [col] plays a knight card and moves the robber to the new index [ind]*)
val play_knight : state -> int -> state

(* [play_road_build st col road1 road2] updates the state when player with color
 * [col] builds a road at [road1] and another at [road2]
 * raises: Failure when a road cannot be build at the chosen spot *)
val play_road_build : state -> road -> road -> state

(* [play_monopoly st r] updates the state when player plays monopoly
 * card at state [st] to acquire resouces [r] *)
val play_monopoly : state -> resource -> state

(* [play_year_of_plenty st r1 r2] updates the state when player plays a
 * year_of_plenty card at state [st] to acquire resources [r1] [r2] *)
val play_year_of_plenty : state -> resource -> resource -> state

(*****************************************************************************
 *                                 RESOURCES                                 *
 *****************************************************************************)

(* [fetch_tiles i] fetches the list of tiles associated with dice roll
 * number [i] *)
val fetch_tiles : int -> Tile.tile list -> Tile.tile list

(* [generate_resource st num] generates the resource at dice roll
 * [num] under state [st] and updates the state after generation *)
val generate_resource : state -> int -> state

(* [discard_resource] discards resources for one player when robber is activated
 * if the player does not have total resource number exceeding 7, then the
 * original state is returned.
 * raises: Failure "you need to discard more resources" or
           Failure "you need to discard fewer resources" if the number of
 * discarded resources entered by the player is wrong *)
val discard_resource : color -> state -> (resource*int) list -> state

(*****************************************************************************
 *                                  POINTS                                   *
 *****************************************************************************)

(* [longest_road st] returns the player who has the longest road token *)
val longest_road : state -> state

(* [largest_army st] returns the player who has the largest army token *)
val largest_army : state -> state

(* [check_win st col] calculates score for player with color [col]
 * at state [st] and checks whether the player has won the game *)
val check_win : state -> color -> bool

(*****************************************************************************
 *                                    DO                                     *
 *****************************************************************************)

(* [end_turn st] updates the player's state when his turn is ended
 * raises: Not_found if player does not exist *)
val end_turn : state -> state

(* [do_player st] returns the state after a player finishes a turn *)
val do_player : state -> Command.command -> color option -> state

(* [do_ai st] returns the state after an AI finishes a turn *)
val do_ai : state -> state
