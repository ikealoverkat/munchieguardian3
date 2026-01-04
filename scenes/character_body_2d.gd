extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -250.0
const RUN_SCALE = Vector2(0.08, 0.08)
const JUMP_SCALE = Vector2(0.1, 0.1)
const IDLE_SCALE = Vector2(0.075, 0.075)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$munchieguardianSprite.play("jumping")
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		$munchieguardianSprite.play("jumping")
		set_scale_for_state("jump")
		
		if direction != 0:
			velocity.x = direction * 0.8 * SPEED
			update_sprite_direction(direction)
	
	else:
		if direction != 0:
			velocity.x = direction * SPEED
			$munchieguardianSprite.play("running")
			set_scale_for_state("run")
			update_sprite_direction(direction)
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$munchieguardianSprite.play("idle")
			set_scale_for_state("idle")

	move_and_slide()

func update_sprite_direction(direction: float) -> void:
	var should_flip = direction < 0 #should flip when facing left
	$munchieguardianSprite.flip_h = should_flip
	$Staff.flip_h = should_flip

func set_scale_for_state(state: String) -> void:
	match state:
		"run":
			$munchieguardianSprite.scale = RUN_SCALE
			$CollisionShape2D.scale = RUN_SCALE
		"idle":
			$munchieguardianSprite.scale = IDLE_SCALE
			#$CollisionShape2D.scale = IDLE_SCALE
		"jump":
			$munchieguardianSprite.scale = JUMP_SCALE
			#$CollisionShape2D.scale = JUMP_SCALE			
	
