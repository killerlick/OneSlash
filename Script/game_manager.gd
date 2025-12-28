extends Node

@export var level : int

@onready var match_start : Timer = $Match_start
@onready var animation_level : AnimationPlayer= $"../LevelAnimation"


var opponent :Opponent
var main_character : Main_character
var hud : HUD
var dual_begin : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opponent = get_parent().get_node("Opponent")
	main_character = get_parent().get_node("MainCharacter")
	hud = get_parent().get_node("Hud")
	var scene_path = get_tree().current_scene.scene_file_path
	if scene_path.ends_with("1.tscn"):
		Global.current_chance = Global.CHANCE_NUMBER
		Global.current_level = 1
	await get_tree().process_frame
	animation_level.play("level_begin")

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
			#begin_the_round()
			pass


#commence le round
func begin_the_round() -> void :
	print("le match commence dans 1 2 3 ...")
	hud.animation_compte_a_rebour()
	match_start.start()

#si vous ne slasher au bon moment , donc echouer le round
func handle_miss() -> void:
	main_character.hide_sign()
	main_character.missed()
	Global.current_chance = Global.current_chance - 1
	if(Global.current_chance == 0):
		game_over()
		return
	else:
		hud.remove_heart()
		begin_the_round()
	opponent.restart_all()

#si vous slasher au bon moment
func handle_success() -> void:
	main_character.hide_sign()
	main_character.slash()
	hud.animation_flash()
	dual_begin=true
	opponent.hitted()


	#condition et fonction de victoire
func win_game():
	hud.show_winning_dual()
	
	
#situation game over
func game_over():
	opponent.stop_all()
	dual_begin = false
	print("game over")
	Global.current_chance = Global.CHANCE_NUMBER
	hud.show_game_over()

	#si vous slasher trop tard et l'ennemi vous attaque
func _on_opponent_attacking() -> void:
	handle_miss() # Replace with function body.

#signal recu que l'ennemi va attaquer
func _on_opponent_will_attack() -> void:
	main_character.show_sign("sure") # Replace with function body.

func _on_match_start_timeout() -> void:
	match_start.set_wait_time(3.0)
	print("le match commence")
	opponent.ennemy_start()
	dual_begin = true # Replace with function body.


func _on_opponent_vanished() -> void:
	opponent.stop_all()
	win_game()


func _on_level_animation_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "level_begin"):
		begin_the_round()
