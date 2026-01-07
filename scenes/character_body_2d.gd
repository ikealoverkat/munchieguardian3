extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -250.0
const RUN_SCALE = Vector2(0.08, 0.08)
const JUMP_SCALE = Vector2(0.1, 0.1)
const IDLE_SCALE = Vector2(0.075, 0.075)
const DASH_SPEED = 250

var dash_direction = 0
var isDashing = false
var dashTimeElapsed = 0
const DASH_TIME = 0.4

@onready var dash: GPUParticles2D = $DashParticles
var dashTimer: float = 0.0

func _ready() -> void:
		dash.emitting = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$munchieguardianSprite.play("jumping")
	
	#print(dash.emitting)
	if dashTimer > 0:
		dashTimer -= delta
	if dashTimer <= 0:
		dash.emitting = false
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
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

	if Input.is_action_just_pressed("move_dash"):
		#if dash_direction == 0:
			#dash_direction = -1.0 if $munchieguardianSprite.flip_h else 1.0
		#
		velocity.x = dash_direction * DASH_SPEED
		
		isDashing = true
		
		#ok im hopping off note to self theres something wrong with line 61 and also my dash shader still is bbroken
		
		if isDashing == true:
			position.x = lerp(position.x, position.x + (dash_direction * 50), DASH_TIME)
			dashTimeElapsed += delta
			if dashTimeElapsed == DASH_TIME:
				isDashing = false
				dashTimeElapsed = 0
			
		
		dash.emitting = true
		dashTimer = 0.4
	
	if not isDashing:
		move_and_slide()

func update_sprite_direction(direction: float) -> void:
	var should_flip = direction < 0 #should flip when facing left
	$munchieguardianSprite.flip_h = should_flip
	$Staff.flip_h = should_flip
	var newVec2 = Vector2(direction, -direction)
	dash.scale.x = newVec2.x
	dash_direction = should_flip
	

func set_scale_for_state(state: String) -> void:
	match state:
		"run":
			$munchieguardianSprite.scale = RUN_SCALE
			$CollisionShape2D.scale = RUN_SCALE
		"idle":
			$munchieguardianSprite.scale = IDLE_SCALE
		"jump":
			$munchieguardianSprite.scale = JUMP_SCALE		

# above: munchieguardian basic movement & scale-setting code
