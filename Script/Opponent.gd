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

@onready var timing :Label =  $Timing

@onready var reaction_time     : Timer = $Reaction_time
@onready var sprite : Sprite2D = $Sprite2D

var current_phase : int = 1
var phase_lenght : int

var action_timer_key : Array[float]

var action_queue : Array = []

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

func set_time_attack() -> void:
	
	action_queue.clear()
	var hit_number : int  = opponent_ressources.get_number_hit(current_phase-1)
	var feint_number : int = opponent_ressources.get_number_feint(current_phase - 1)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for i in range(hit_number + feint_number):
		var action_time = rng.randf()*opponent_ressources.nb_time_remaining + opponent_ressources.nb_delay
		var action_type="hit" 
		if(hit_number > 0):
			hit_number -= 1
		else:
			action_type = "feint"
		action_queue.append(
		{
			"time" : action_time,
			"type" : action_type
		}
	)
	sort_list()

#transforme hit_timer pour mieux arranger les timer
func sort_list() -> void:
	action_queue.sort_custom(
		func(a,b):
			return a.time < b.time
	)
	for i in range (action_queue.size() - 1,0, -1):
		action_queue[i].time -= action_queue[i - 1].time

#fonction qui set la prochaine attack de hit_timer(prochaine du monstre selon la liste)
func ennemy_start_next_action():
	var next_action = action_queue.pop_front()
	
	if(next_action.type == "hit"):
		timer_for_attacking.set_wait_time(next_action.time)
		timer_for_attacking.start()
	elif (next_action.type == "feint"):
		timer_for_feinting.set_wait_time(0.5)
		timer_for_feinting.start()
		
	state = Global.Opponent_state.PREPARING

#se lance quand oppoenent se fait hit
func hitted()-> void:
	show_timing(reaction_time.time_left)
	reaction_time.stop()
	reaction_time.set_wait_time(opponent_ressources.nb_reaction_time)
	if(action_queue.size() <= 0 ):
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

func show_timing(time : float ) -> void :
	var max_time = opponent_ressources.nb_reaction_time
	var timing_time_remaining = max_time-time
	
	var ratio = timing_time_remaining / max_time
	var result = ""
	print(str(ratio) +"    "+ str(max_time))
	
	if ratio >= 0.8:
		result = "OK"
	elif ratio >= 0.4:
		result = "GOOD"
	else:
		result = "PERFECT"
	timing.set_text(result)
	timing.set_visible(true)
	await get_tree().create_timer(0.3).timeout
	timing.set_visible(false)




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
	sprite.set_flip_h(true)
	print("il va feinté")
	timer_after_feint.set_wait_time(0.5)
	timer_after_feint.start()
	feint.emit() 

func _on_timer_after_feint_timeout() -> void:
	sprite.set_flip_h(false)
	hitted()
	pass # Replace with function body.
