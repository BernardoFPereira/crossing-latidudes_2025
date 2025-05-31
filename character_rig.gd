extends Node3D

@export var target: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y = lerp(global_position.y, target.global_position.y, delta)

func switch_target(new_target):
	target = new_target
