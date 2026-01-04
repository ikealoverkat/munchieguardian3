extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -250.0
const RUN_SCALE = 0.08
const JUMP_SCALE = 0.1
const IDLE_SCALE = 0.075


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$munchieguardianSprite.play("jumping")
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		$munchieguardianSprite.play("jumping")
		$munchieguardianSprite.scale = Vector2(JUMP_SCALE, JUMP_SCALE)
		$CollisionShape2D.scale = Vector2(JUMP_SCALE, JUMP_SCALE)
		
		if direction == 1.0:
			$munchieguardianSprite.flip_h = false
			$Staff.flip_h = false
			
		if direction == -1.0:
			$munchieguardianSprite.flip_h = false
			$Staff.flip_h = false
	else:
		if direction == 1.0:
			velocity.x = direction * SPEED
			$munchieguardianSprite.play("running")
			$munchieguardianSprite.flip_h = false
			$Staff.flip_h = false
			$munchieguardianSprite.scale = Vector2(RUN_SCALE, RUN_SCALE)
			$CollisionShape2D.scale = Vector2(RUN_SCALE, RUN_SCALE)
			
		elif direction == -1.0:
			velocity.x = direction * SPEED
			$munchieguardianSprite.play("running")
			$munchieguardianSprite.flip_h = true
			$Staff.flip_h = true
			$munchieguardianSprite.scale = Vector2(RUN_SCALE, RUN_SCALE)
			$CollisionShape2D.scale = Vector2(RUN_SCALE, RUN_SCALE)
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$munchieguardianSprite.play("idle")
			$munchieguardianSprite.scale = Vector2(IDLE_SCALE, IDLE_SCALE)
			$CollisionShape2D.scale = Vector2(IDLE_SCALE, IDLE_SCALE)

	move_and_slide()
