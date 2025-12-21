extends Node2D

@onready var animation = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func missed() -> void:
	animation.play("missed")

func slash() -> void:
	animation.play("slash")
	pass
