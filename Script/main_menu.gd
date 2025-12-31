extends Control

@onready var animation_character : AnimationPlayer = $Image_title/AnimationPlayer


func _ready() -> void:
	animation_character.play("lobby")


func _process(delta: float) -> void:
	pass


func _on_exit_button_up() -> void:
	get_tree().quit() # Replace with function body.


func _on_play_button_up() -> void:
	get_tree().change_scene_to_file("res://Scene/Levels/Level_1.tscn")
