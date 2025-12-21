extends Node

@onready var match_start = $Match_start

var opponent
var main_character 
var hud
var dual_begin : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opponent = get_parent().get_node("Opponent")
	main_character = get_parent().get_node("MainCharacter")
	hud = get_parent().get_node("Hud")
  

func begin_the_round() -> void :
	print("le match commence dans 1 2 3 ...")
	hud.animation_compte_a_rebour()
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

#si vous ne slasher au bon moment , donc echouer le round
func handle_miss() -> void:
	main_character.hide_sign()
	main_character.missed()
	Global.current_chance = Global.current_chance - 1
	if(Global.current_chance == 0):
		game_over()
		return
	opponent.restart_all()

#si vous slasher au bon moment
func handle_success() -> void:
	main_character.hide_sign()
	main_character.slash()
	hud.animation_flash()
	dual_begin=false
	opponent.stop_all()
	
	#si vous slasher trop tard et l'ennemi vous attaque
func _on_opponent_attacking() -> void:
	handle_miss() # Replace with function body.

#situation game over
func game_over():
	print("game over")
	get_tree().quit()

#signal recu que l'ennemi va attquer
func _on_opponent_will_attack() -> void:
	main_character.show_sign("sure") # Replace with function body.

#condition et fonction de victoire
func win_game():
	pass
