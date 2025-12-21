extends Node2D

signal attacking
signal will_attack



var state : Global.Opponent_state ;

@export var opponent : Opponent ;

@onready var timer_for_attacking : Timer = $Timer_for_attacking
@onready var reaction_time     : Timer = $Reaction_time

@onready var sprite : Sprite2D = $Sprite2D



func _ready() -> void:
	if(opponent == null):
		print('pas d\'opponent assigner ')
		return
	if(opponent.sprite2D != null):
		sprite.texture = opponent.sprite2D
	state = Global.Opponent_state.NOT_READY
	reaction_time.set_wait_time(opponent.nb_reaction_time) 

func waiting_time() -> void:
	var randomGenerator = RandomNumberGenerator.new()
	var action_time = randomGenerator.randf()*opponent.nb_time_remaining + opponent.nb_delay
	timer_for_attacking.set_wait_time(action_time)
	state = Global.Opponent_state.PREPARING
	timer_for_attacking.start()


# l'instant ou l'ennemi va attaquer et que le joueur va slash
func _on_timer_for_attacking_timeout() -> void:
	print("l'ennemi va attaquer")
	will_attack.emit()
	state = Global.Opponent_state.DEGAINING
	reaction_time.start() 




 # emet le signal comme quoi l'ennemi a attaquer
func _on_reaction_time_timeout() -> void:
	print("il a attaqué")
	attacking.emit()




func restart_all():
	timer_for_attacking.stop()
	reaction_time.stop()
	reaction_time.set_wait_time(opponent.nb_reaction_time)
	state = Global.Opponent_state.NOT_READY


func stop_all():
	timer_for_attacking.stop()
	reaction_time.stop()
