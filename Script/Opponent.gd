extends Node2D
class_name Opponent

signal attacking
signal will_attack
signal will_feint
signal vanished
signal prepare_next_phase



var state : Global.Opponent_state ;

@export var opponent_ressources : Opponent_ressources ;
@onready var timer_for_attacking : Timer = $Timer_for_attacking
@onready var reaction_time     : Timer = $Reaction_time
@onready var sprite : Sprite2D = $Sprite2D

var current_phase : int = 1
var phase_lenght : int

var hit_timer : Array[float] = []
var feint_timer :  Array[float] = []

func _ready() -> void:
	if(opponent_ressources == null):
		print('pas d\'opponent assigner ')
		return
	if(opponent_ressources.sprite_main != null):
		sprite.texture = opponent_ressources.sprite_main
		phase_lenght = opponent_ressources.get_number_phase()
	state = Global.Opponent_state.NOT_READY
	reaction_time.set_wait_time(opponent_ressources.nb_reaction_time) 
	set_time_attack()

#fonction qui va determiner a quel moment le monstre attaque
func set_time_attack() -> void:
	hit_timer.clear()
	for i in range(opponent_ressources.get_number_hit(current_phase -1)):
		var randomGenerator = RandomNumberGenerator.new()
		var action_time = randomGenerator.randf()*opponent_ressources.nb_time_remaining + opponent_ressources.nb_delay
		hit_timer.push_back(action_time)
	sort_list()
	print(hit_timer)

# transforme la liste timer pour represente le temps au quel le monstre attaque
func sort_list() -> void:
	hit_timer.sort()
	var result: Array[float] = []
	for i in range(hit_timer.size()):
		if i == 0:
			result.append(hit_timer[i])
		else:
			result.append(hit_timer[i] - hit_timer[i - 1])
	hit_timer = result

func ennemy_start_next_attack():
	timer_for_attacking.set_wait_time(hit_timer.pop_front())
	state = Global.Opponent_state.PREPARING
	timer_for_attacking.start()

func hitted()-> void:
	reaction_time.stop()
	reaction_time.set_wait_time(opponent_ressources.nb_reaction_time)
	if(hit_timer.size() <= 0 ):
		if current_phase >= phase_lenght:
			vanished.emit()
		else:
			current_phase = current_phase + 1
			set_time_attack()
			prepare_next_phase.emit()
	else:
		state = Global.Opponent_state.PREPARING
		await get_tree().create_timer(0.1).timeout
		ennemy_start_next_attack()

func restart_all():
	print("enemy reinitialiser")
	timer_for_attacking.stop()
	reaction_time.stop()
	set_time_attack()
	state = Global.Opponent_state.NOT_READY

func stop_all():
	print("ennemi a nagit plus")
	state = Global.Opponent_state.NOT_READY
	timer_for_attacking.stop()
	reaction_time.stop()

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
