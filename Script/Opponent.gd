extends Node2D
class_name Opponent

var KEY = 0
var VALUE = 1

signal attacking
signal will_attack
signal feint
signal vanished
signal prepare_next_phase



var state : Global.Opponent_state ;

@export var opponent_ressources : Opponent_ressources ;
@onready var timer_for_attacking : Timer = $Timer_for_attacking
@onready var timer_for_feinting : Timer = $Timer_for_feinting
@onready var timer_after_feint : Timer = $Timer_after_feint

@onready var reaction_time     : Timer = $Reaction_time
@onready var sprite : Sprite2D = $Sprite2D

var current_phase : int = 1
var phase_lenght : int

#var hit_timer : Array[float] = []

var action_timer_key : Array[float]
var action_timer : Dictionary = {}

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

#fonction qui set action_timer(array timer d'attack)
#func set_time_attack() -> void:
	#hit_timer.clear()
	#for i in range(opponent_ressources.get_number_hit(current_phase -1)):
		#var randomGenerator = RandomNumberGenerator.new()
		#var action_time = randomGenerator.randf()*opponent_ressources.nb_time_remaining + opponent_ressources.nb_delay
		#hit_timer.push_back(action_time)
	#sort_list()
	#print(hit_timer)

func set_time_attack() -> void:
	action_timer.clear()
	var hit_number : int  = opponent_ressources.get_number_hit(current_phase-1)
	var feint_number : int = opponent_ressources.get_number_feint(current_phase - 1)
	
	for i in range(opponent_ressources.get_all_hit_number(current_phase -1)):
		var randomGenerator = RandomNumberGenerator.new()
		var action_time = randomGenerator.randf()*opponent_ressources.nb_time_remaining + opponent_ressources.nb_delay
		if(hit_number > 0):
			action_timer[action_time] = "hit"
			hit_number -= 1
		else:
			action_timer[action_time] = "feint"

	sort_list()

#transforme hit_timer pour mieux arranger les timer
func sort_list() -> void:
	
	var hit_timer : Array = action_timer.keys()
	hit_timer.sort()
	var hit_type : Array = action_timer.values() 
	hit_type.shuffle()
	var result: Array[float] = []
	
	for i in range(action_timer.size()):
		if i == 0:
			result.append(hit_timer[i])
		else:
			result.append(hit_timer[i] - hit_timer[i - 1])
	
	hit_timer = result
	action_timer.clear()
	
	for i in range(hit_timer.size()):
		action_timer[hit_timer[i]] = hit_type[i]

#fonction qui set la prochaine attack de hit_timer(prochaine du monstre selon la liste)
func ennemy_start_next_action():
	var next_action = pop_front_dictionary(action_timer)
	
	if(next_action[VALUE] == "hit"):
		timer_for_attacking.set_wait_time(next_action[KEY])
		timer_for_attacking.start()
	elif (next_action[VALUE] == "feint"):
		timer_for_feinting.set_wait_time(0.5)
		timer_for_feinting.start()
		
	state = Global.Opponent_state.PREPARING


#se lance quand oppoenent se fait hit
func hitted()-> void:
	reaction_time.stop()
	reaction_time.set_wait_time(opponent_ressources.nb_reaction_time)
	if(action_timer.size() <= 0 ):
		if current_phase >= phase_lenght:
			vanished.emit()
		else:
			current_phase = current_phase + 1
			set_time_attack()
			prepare_next_phase.emit()
	else:
		state = Global.Opponent_state.PREPARING
		await get_tree().create_timer(0.1).timeout
		ennemy_start_next_action()


func pop_front_dictionary(dic : Dictionary) -> Array :
	var key = dic.keys()[0]
	var value = dic.values()[0]
	dic.erase(key)
	return [key,value]

#arrete l'oponnent et refait hit_timer(liste dattaque)
func restart_all():
	timer_for_attacking.stop()
	reaction_time.stop()
	timer_after_feint.stop()
	timer_for_feinting.stop()
	set_time_attack()
	state = Global.Opponent_state.NOT_READY

#disabled l'opponent entierement
func stop_all():
	state = Global.Opponent_state.NOT_READY
	timer_for_attacking.stop()
	reaction_time.stop()
	timer_after_feint.stop()
	timer_for_feinting.stop()

# l'instant ou l'ennemi va attaquer et que le joueur doit slash
func _on_timer_for_attacking_timeout() -> void:
	print("l'ennemi va attaquer")
	will_attack.emit()
	state = Global.Opponent_state.DEGAINING
	reaction_time.start()


 # emet le signal comme quoi l'ennemi a attaquer
func _on_reaction_time_timeout() -> void:
	print("il a attaqué")
	attacking.emit()


func _on_timer_for_feinting_timeout() -> void:
	print("il va feinté")
	timer_after_feint.set_wait_time(0.5)
	timer_after_feint.start()
	feint.emit() 


func _on_timer_after_feint_timeout() -> void:
	print("1")
	hitted()
	pass # Replace with function body.
