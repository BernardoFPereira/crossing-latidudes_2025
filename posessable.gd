extends RigidBody3D
class_name Possessable

@onready var highlight: MeshInstance3D = $MeshInstance3D/Highlight
#@onready var ray_cast: RayCast3D = $RayCast3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var selectable := false
var player: Player

enum States {
	IDLE,
	POSSESSED,
}

var state: States

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	state = States.IDLE
	
	# USE THIS FOR OUTLINE MESH
	if !highlight.mesh:
		highlight.mesh = mesh_instance_3d.mesh.create_outline(0.1)
		highlight.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_state(new_state: States) -> void:
	state = new_state
	
	match state:
		States.IDLE:
			gravity_scale = 1
			pass
		States.POSSESSED:
			gravity_scale = 0
			pass

func handle_states(delta):
	match state:
		States.IDLE:
			pass
		States.POSSESSED:
			rotation.move_toward(Vector3.ZERO, delta * 8)
			# Make thing float
			#recalculate_height(delta)
			pass
	pass
	
#func recalculate_height(delta:float):
	#ray_cast.force_raycast_update()
	#var max_ground_distance = 20
	#var ground_distance = ray_cast.get_collision_point() - global_position
	#print(ground_distance)
	#if ground_distance.length() < max_ground_distance:
		#global_position.y += ground_distance * delta
	#
	#if ground_distance.length() >= max_ground_distance:
		#pass
	#else:
		#height_Pos = Vector3.UP * 2

func _on_mouse_entered() -> void:
	if player.state != player.States.CONTROLLING:
		player.possession_target = self
	
	highlight.visible = true
	selectable = true

func _on_mouse_exited() -> void:
	if player.state != player.States.CONTROLLING:
		player.possession_target = null
	
	highlight.visible = false
	selectable = false

#func _on_timer_timeout() -> void:
	#print("going to possessed")
	#set_state(States.POSSESSED)
