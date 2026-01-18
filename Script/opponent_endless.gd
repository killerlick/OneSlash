extends Opponent
class_name EndlessEnemy

var LEVEL_MAX : int     = 50
@export var current_level : int = 1

#duree dans laquel lennemi (tout les attaque se font dans ce lapse de temps)
var nb_time_remaining = 5.0

#temps avant que bigmcraga
var nb_reaction_time = 1.0 #0.150 MINIMUM


var endless_hit_number : int
var endless_feint_number : int


func _ready() -> void:
	if(opponent_ressources.sprite_main != null):
		sprite.texture = opponent_ressources.sprite_main
	phase_lenght = LEVEL_MAX
	state = Global.Opponent_state.NOT_READY
	reaction_time.set_wait_time(opponent_ressources.nb_reaction_time) 
	set_time_attack()

func set_time_attack() -> void:
	set_round()
	action_timer.clear()
	var hit_number : int  = endless_hit_number
	var feint_number : int = endless_feint_number
	
	for i in range(hit_number + feint_number):
		var randomGenerator = RandomNumberGenerator.new()
		var action_time = randomGenerator.randf()*opponent_ressources.nb_time_remaining + opponent_ressources.nb_delay
		if(hit_number > 0):
			action_timer[action_time] = "hit"
			hit_number -= 1
		else:
			action_timer[action_time] = "feint"
	sort_list()


func set_round () -> void :
	dificulty_selection(calculate_dificulty(current_level))
	set_enemy_action()



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

func calculate_dificulty(level : int) ->   float :
	return clamp( level/5 , 0 ,10)

func prepare_phase() -> void :
	pass

func set_enemy_action() -> void :
	nb_time_remaining = nb_time_remaining - calculate_dificulty(current_level)*0.2
	nb_reaction_time = nb_reaction_time + (endless_feint_number+endless_hit_number)*0.3
	nb_reaction_time = nb_reaction_time - calculate_dificulty(current_level)*0.085

func dificulty_selection(level : int)   ->  void :
	match int(level) :
		0:
			endless_feint_number = randi_range(0 , 1)
			endless_hit_number   = randi_range(1,4)
		1:
			endless_feint_number = randi_range(0 , 1)
			endless_hit_number   = randi_range(2,4)
		2:
			endless_feint_number = randi_range(0 , 2)
			endless_hit_number   = randi_range(3,4)
		3:
			endless_feint_number = randi_range(0 , 2)
			endless_hit_number   =  randi_range(3,6)
		4:
			endless_feint_number = randi_range(1 , 2)
			endless_hit_number   = randi_range(4,6)
		5:
			endless_feint_number = randi_range(1 , 2)
			endless_hit_number   = randi_range(5,6)
		6:
			endless_feint_number = randi_range(1,2)
			endless_hit_number   = randi_range(5,8)
		7:
			endless_feint_number = randi_range(1 , 3)
			endless_hit_number   = randi_range(6,8)
		8:
			endless_feint_number = randi_range(1 , 3)
			endless_hit_number   = randi_range(7,9)
		9:
			endless_feint_number = randi_range(1 , 3)
			endless_hit_number   = randi_range(6,11)
		10:
			endless_feint_number = randi_range(0 ,1 )
			endless_hit_number   = randi_range(10,12)
