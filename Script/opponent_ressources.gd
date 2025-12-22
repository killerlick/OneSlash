extends Resource
class_name Opponent_ressources

signal cd

@export var opponent_name :String;
@export var sprite_feint :Array[Texture2D] = [];
@export var sprite_main : Texture2D
@export var sprite_attacking: Texture2D
@export var sprite_defeated: Texture2D


@export var number_hit_by_phase : Array[int] = [] ;

@export var nb_reaction_time  : float = 2.0;
@export var nb_delay          : float = 1.0;
@export var nb_time_remaining : float = 7.0;
