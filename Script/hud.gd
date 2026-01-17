extends CanvasLayer
class_name  HUD

signal slash_finished
signal compte_a_rebour_finished

@onready var animation : AnimationPlayer = $Animation
@onready var flash_blanc : AnimationPlayer = $Flash_blanc

@onready var rectangle_blanc : TextureRect = $TextureRect
@onready var decompte : Label = $Decompte
@onready var display_round : Label = $Display_round
@onready var health_display : GridContainer = $Health_display
@onready var health_model = $Health_model

@onready var match_display  = $Match_display
@onready var game_over_display  =$Match_display/Game_over_display
@onready var game_win_display  = $Match_display/Game_win_display


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rectangle_blanc.visible = false
	decompte.visible = false
	health_model.visible = false
	display_round.visible = false
	
	match_display.visible = false
	game_over_display.visible = false
	game_win_display.visible = false
	
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
		
	if(anim_name == "round_animation" ):
		animation_compte_a_rebour()
		display_round.visible = false

func animation_flash() -> void:
	rectangle_blanc.visible = true
	flash_blanc.play("slash")

func animation_compte_a_rebour() -> void:
	decompte.visible = true
	animation.play("compte a rebour")

func animation_round(round_number : int) -> void:
	display_round.visible = true
	display_round.set_text("ROUND " +  str(round_number))
	animation.play("round_animation")

func show_winning_dual():
	match_display.visible = true
	game_win_display.visible = true

func show_game_over():
	match_display.visible = true
	game_over_display.visible = true


func _on_next_pressed() -> void:
	Global.go_next_level() 

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn") # Replace with function body.

func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()
