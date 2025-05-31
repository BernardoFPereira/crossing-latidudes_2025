extends RigidBody3D

@onready var highlight: MeshInstance3D = $MeshInstance3D/Highlight

var selectable := false
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	if !player.is_out_of_body:
		player.possession_target = self
	
	highlight.visible = true
	selectable = true
	

func _on_mouse_exited() -> void:
	if !player.is_out_of_body:
		player.possession_target = null
	
	highlight.visible = false
	selectable = false
