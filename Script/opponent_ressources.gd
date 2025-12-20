extends Resource
class_name Opponent

signal cd

@export var opponent_name :String;
@export var sprite2D :Texture2D;


@export var number_phase = 1 ;

@export var nb_reaction_time  : float = 2.0;
@export var nb_delay          : float = 1.0;
@export var nb_time_remaining : float = 7.0;
