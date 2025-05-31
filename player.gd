extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var possession_target: RigidBody3D
var is_out_of_body := false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_far", "move_close")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_out_of_body:
		if direction:
			possession_target.linear_velocity.x = direction.x * SPEED
			possession_target.linear_velocity.z = direction.z * SPEED
		else:
			possession_target.linear_velocity.x = move_toward(velocity.x, 0, SPEED)
			possession_target.linear_velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		
	if input_dir == Vector2.ZERO:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("posess") and possession_target != null:
		is_out_of_body = true
		
	if event.is_action_pressed("return_to_body"):
		is_out_of_body = false
