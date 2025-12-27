extends CanvasLayer
class_name  HUD

signal slash_finished
signal compte_a_rebour_finished

@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var rectangle_blanc : TextureRect = $TextureRect
@onready var decompte : Label = $Decompte
@onready var health_display : GridContainer = $Health_display
@onready var health_model = $Health_model

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rectangle_blanc.visible = false
	decompte.visible = false
	health_model.visible = false
	display_health()


func display_health() -> void:
	for child in health_display.get_children():
		child.queue_free()

	for i in range(Global.current_chance):
		var heart = health_model.duplicate()
		heart.visible = true
		health_display.add_child(heart)

func remove_heart() -> void:
	if health_display.get_child_count() > 0:
		var last_heart = health_display.get_child(health_display.get_child_count() - 1)
		last_heart.queue_free()

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

func show_winning_dual():
	pass
