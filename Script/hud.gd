extends CanvasLayer

signal slash_finished
signal compte_a_rebour_finished

@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var rectangle_blanc : TextureRect = $TextureRect
@onready var decompte : Label = $Decompte


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rectangle_blanc.visible = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "slash"):
		slash_finished.emit()
		rectangle_blanc.visible = false
	if(anim_name == "compte a rebour"):
		compte_a_rebour_finished.emit()
		decompte.visible = false

func animation_flash() -> void:
	rectangle_blanc.visible = true
	animation.play("slash")

func animation_compte_a_rebour() -> void:
	decompte.visible = true
	animation.play("compte a rebour")
