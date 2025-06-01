extends CharacterBody3D
class_name Player

@export var move_speed = 5.0
@export var lift_power := 40.0
@export var max_lift_power := 200.0

@onready var camera_ray: RayCast3D = $"../Camera3D/CameraRay"

var jump_force = 4.5
var possession_target: Possessable
#var is_out_of_body := false
var vertical_force := 0
var height_vector := Vector3.ZERO

enum States {
	IDLE,
	WALK,
	FALL,
	CONTROLLING,
}

var state :=  States.IDLE

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	handle_states(delta)
	move_and_slide()

func handle_input() -> void:
	pass

func set_state(new_state: States) -> void:
	state = new_state
	
	if state in [States.IDLE, States.WALK, States.FALL]:
		pass
	else:
		pass

func handle_states(delta) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_far", "move_close")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	match state:
		States.IDLE:
			if direction:
				set_state(States.WALK)
				
			velocity.x = lerp(velocity.x, 0.0, delta * 4)
			velocity.z = lerp(velocity.z, 0.0, delta * 4)
		
		States.WALK:
			if !is_on_floor():
				set_state(States.FALL)
			if input_dir != Vector2.ZERO:
				velocity = direction * move_speed
			else:
				set_state(States.IDLE)
			
		States.FALL:
			if is_on_floor():
				set_state(States.IDLE)
			pass
		
		States.CONTROLLING:
			if possession_target.state not in [possession_target.States.IDLE]:
				velocity.x = lerp(velocity.x, 0.0, delta * 6)
				velocity.z = lerp(velocity.z, 0.0, delta * 6)
				
				if direction:
					possession_target.linear_velocity.x = direction.x * (move_speed / 2)
					possession_target.linear_velocity.z = direction.z * (move_speed / 2)
				else:
					possession_target.linear_velocity.x = move_toward(possession_target.linear_velocity.x, 0, delta * 12)
					possession_target.linear_velocity.z = move_toward(possession_target.linear_velocity.z, 0, delta * 12)
				if vertical_force != 0.0:
					possession_target.linear_velocity.y = vertical_force * delta
				else:
					possession_target.linear_velocity.y = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("posess") and possession_target != null:
		set_state(States.CONTROLLING)
		possession_target.set_state(possession_target.States.POSSESSED)
		#is_out_of_body = true
		
	if event.is_action_pressed("return_to_body"):
		if possession_target != null:
			set_state(States.WALK)
			possession_target.set_state(possession_target.States.IDLE)
			possession_target = null
		#is_out_of_body = false
	
	if event.is_action("lift_object"):
		if state == States.CONTROLLING:
			if abs(vertical_force) < max_lift_power:
				vertical_force += lift_power
			
	if event.is_action("lower_object"):
		if state == States.CONTROLLING:
			if abs(vertical_force) < max_lift_power:
				vertical_force -= lift_power
			
	if event.is_action_released("lift_object"):
		vertical_force = 0
	if event.is_action_released("lower_object"):
		vertical_force = 0
		
#func get_possession_target() -> void:
	#camera_ray.target_position = 
