extends Node2D
class_name Main_character

@onready var animation = $AnimationPlayer
@onready var not_sure = $Not_sure
@onready var sure = $Sure
@onready  var slash_sound : AudioStreamPlayer = $Slash_sound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sure.visible = false
	not_sure.visible = false

func missed() -> void:
	animation.play("missed")

func slash() -> void:
	play_slash_sound()
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

func play_slash_sound():
	slash_sound.set_pitch_scale(randf_range(0.99 , 1.05))
	slash_sound.play()
	
	pass
