extends Control

@onready var animation : AnimationPlayer = $MarginContainer/VBoxContainer/Label2/AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("slow_sparkling")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
