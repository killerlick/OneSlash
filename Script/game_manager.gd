extends Node

@onready var match_start = $Match_start

var opponent
var dual_begin : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opponent = get_parent().get_node("Opponent")
  

func begin_the_round() -> void :
	print("le match commence dans 1 2 3 ...")
	match_start.start()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and dual_begin:
			match opponent.state:
				Global.Opponent_state.PREPARING:
					handle_miss()
				Global.Opponent_state.DEGAINING:
					handle_success()
		elif event.pressed and event.button_index == MOUSE_BUTTON_LEFT and opponent.state == Global.Opponent_state.NOT_READY:
			print("touch some grass , on a pas encore commencé lol")
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			begin_the_round()

func _on_match_start_timeout() -> void:
	match_start.set_wait_time(2.0)
	print("le match commence")
	opponent.waiting_time()
	dual_begin = true # Replace with function body.

func handle_miss() -> void:
	print("tu as raté")
	Global.current_chance = Global.current_chance - 1
	if(Global.current_chance == 0):
		game_over()
		return
	opponent.restart_all()

func handle_success() -> void:
	print("GG")
	dual_begin=false
	opponent.stop_all()
	
func _on_opponent_attacking() -> void:
	handle_miss() # Replace with function body.

func game_over():
	get_tree().quit()

func win_game():
	pass
