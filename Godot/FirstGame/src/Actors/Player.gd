extends Actor



var state_machine


var _canHit = true
var _melee = false
var _hitting = false


var timer = null
var hit_delay = 0.5

func _ready():
	
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(hit_delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	
	state_machine = $AnimationTree.get("parameters/playback")


func _process(delta):
	SkillLoop()
	AnimationLoop(_velocity)

func _physics_process(delta: float)->void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	



func SkillLoop () -> void:
	if Input.is_action_pressed("MeleeAttack") and _canHit == true:
		_canHit = false
		_velocity.x = 0
		_melee = true
		_hitting = true
		timer.start()
	yield(get_tree().create_timer(1), "timeout")
	_melee = false
	_hitting = false
func on_timeout_complete():
	_canHit = true


func AnimationLoop(velocity: Vector2) -> void:
	var current = state_machine.get_current_node()
	if _hitting == true:
		if _melee == true and get_hit().y == 0:
			state_machine.travel("Attack_x")
			return
		elif _melee == true and get_hit().y == 1:
			state_machine.travel("Attack_y_Down")
			return
		elif _melee == true and get_hit().y == -1:
			state_machine.travel("Attack_y_Up")
			return
	if velocity.length() == 0:
		state_machine.travel("Idle")
	if velocity.length() > 0:
		state_machine.travel("Run")
	if not is_on_floor():
		state_machine.travel("Jump")
		
	if abs(velocity.x) > 8:
		get_node("player").flip_h = velocity.x < 0
	if get_direction().x == 1:
		get_node("Sword_Hit").scale.x = 1
	elif get_direction().x == -1:
		get_node("Sword_Hit").scale.x = -1
	if get_hit().y == 1:
		get_node("Sword_Hit").scale.y = -1
	elif get_hit().y == -1:
		get_node("Sword_Hit").scale.y = 1
	if velocity.y > 0:
		state_machine.travel("Fall_Run")




func get_hit() -> Vector2:
	return Vector2(
		Input.get_action_strength("attack_right") - Input.get_action_strength("attack_left"),
		Input.get_action_strength("attack_down") - Input.get_action_strength("attack_up")
	)




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


func hurt():
	state_machine.travel("Hurt")
	return

func die():
	state_machine.travel("Die")
	set_physics_process(false)


func _on_Sword_Hit_area_entered(area):
	area.queue_free()


func _on_EnemyDetector_area_entered(area):
	hurt()
