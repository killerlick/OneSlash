extends Node

enum Opponent_state {
	NOT_READY,
	PREPARING,
	DEGAINING
}

const CHANCE_NUMBER = 3
var current_chance = 3

var current_level := 1
var MAX_LEVEL := 3

func go_next_level():
	if current_level < MAX_LEVEL:
		current_level += 1
		var path = "res://Scene/Levels/Level_" + str(current_level) + ".tscn"
		print(path)
		get_tree().change_scene_to_file(path)
	else:
		pass
