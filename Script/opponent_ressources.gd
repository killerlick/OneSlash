extends Resource
class_name Opponent_ressources

signal cd

@export var opponent_name :String;
@export var sprite_feint :Array[Texture2D] = [];
@export var sprite_main : Texture2D
@export var sprite_attacking: Texture2D
@export var sprite_defeated: Texture2D


@export var phase : Array[OpponentPhase] = []


@export var number_hit_by_phase : Array[int] = [] ;

#le temps requis a l'ennemi pour reagir
@export var nb_reaction_time  : float = 2.0;

#le delain utilisé par l'ennemi avant de commencer ces assaut
@export var nb_delay          : float = 1.0;

#la durée dans laquel l'ennemi va attaqueé
@export var nb_time_remaining : float = 7.0;


func _ready() -> void:
	if phase == null :
		var test = OpponentPhase.new()
		test.feint = 0
		test.hit = number_hit_by_phase[0]
		phase.append(test)
