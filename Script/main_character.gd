extends Node2D

@onready var animation = $AnimationPlayer
@onready var not_sure = $Not_sure
@onready var sure = $Sure


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sure.visible = false
	not_sure.visible = false

func missed() -> void:
	animation.play("missed")

func slash() -> void:
	animation.play("slash")
	pass

func show_sign(sign : String ) -> void :
	match sign:
		"not_sure":
			not_sure.visible = true
		"sure":
			sure.visible = true


func hide_sign( ) -> void :
	not_sure.visible = false
	sure.visible = false
