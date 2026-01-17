extends Node2D
class_name Main_character

@onready var animation = $AnimationPlayer
@onready var not_sure = $Not_sure
@onready var sure = $Sure
@onready  var slash_sound : AudioStreamPlayer = $Slash_sound


func _ready() -> void:
	sure.visible = false
	not_sure.visible = false

#fonction si le joueur rate le timing du slash
func missed() -> void:
	animation.play("missed")

#se lance quand le joueur slash correctement
func slash() -> void:
	play_slash_sound()
	animation.play("slash")
	pass

#monstre signe a coté du joueur
func show_sign(sign : String ) -> void :
	match sign:
		"not_sure":
			not_sure.visible = true
		"sure":
			sure.visible = true

#CACHE tout les signe a coté du joueur
func hide_sign() -> void :
	not_sure.visible = false
	sure.visible = false

#affiche le signe pas sure (si ennemi feinte)
func play_not_sure() -> void :
	show_sign("not_sure")
	await get_tree().create_timer(0.3).timeout
	hide_sign()

#joue juste le son du slash
func play_slash_sound():
	slash_sound.set_pitch_scale(randf_range(0.95 , 1.05))
	slash_sound.play()
