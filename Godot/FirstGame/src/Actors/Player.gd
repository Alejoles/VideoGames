extends Actor


func _ready():
	get_node("Sword_x/CollisionShape2D").set_disabled(true)
	get_node("Sword_y/CollisionShape2D").set_disabled(true)


func _on_EnemyDetector_body_entered(body):
	queue_free()


func _physics_process(delta: float)->void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	hit_direction(direction)
	


func get_hit() -> Vector2:
	return Vector2(
		Input.get_action_strength("attack_right") - Input.get_action_strength("attack_left"),
		Input.get_action_strength("attack_down") - Input.get_action_strength("attack_up")
	)


func enable_hit():
	if Input.get_action_strength("general_attack_x") == 1:
		get_node("Sword_x/CollisionShape2D").set_disabled(false)
	else:
		get_node("Sword_x/CollisionShape2D").set_disabled(true)
	if Input.get_action_strength("general_attack_y") == 1:
		get_node("Sword_y/CollisionShape2D").set_disabled(false)
	else:
		get_node("Sword_y/CollisionShape2D").set_disabled(true)


func hit_direction(direction: Vector2):
	if get_hit().x == 1:
		get_node("Sword_x").scale.x = 1
	elif get_hit().x == -1:
		get_node("Sword_x").scale.x = -1
	if get_hit().y == 1:
		get_node("Sword_y").scale.y = -1
	elif get_hit().y == -1:
		get_node("Sword_y").scale.y = 1
	enable_hit()

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out
	
