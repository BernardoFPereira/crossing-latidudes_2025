extends Node

@onready var win_menu: Control = $CanvasLayer/WinMenu

func _on_button_again_pressed() -> void:
	get_tree().reload_current_scene()

func _on_button_quit_pressed() -> void:
	get_tree().quit()

func _on_win_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		win_menu.visible = true
