extends CharacterBody2D

@export var SPEED = -300.0
@export var Max_speed = 400.0 # Match type float
@export var friction = 100.0   # Match type float
@onready var animated_sprite = $AnimatedSprite2D 

func _physics_process(delta: float) -> void:
	# 1. Get the mouse location and calculate direction from player to mouse
	var mouse_pos: Vector2 = get_global_mouse_position()
	var direction_to_mouse: Vector2 = global_position.direction_to(mouse_pos)
	
	# 2. Get the target angle using the vector pointing to the mouse
	var target_angle: float = direction_to_mouse.angle()
	
	# 3. Smoothly rotate the player toward the mouse
	rotation = lerp_angle(rotation, target_angle, 0.1)
	
	# 4. Handle movement and apply friction
	if Input.is_action_pressed("ui_accept"):
		# Set velocity toward the mouse up to Max_speed
		var target_velocity = direction_to_mouse * SPEED
		velocity = target_velocity.limit_length(Max_speed)
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
		# If button is released, apply friction smoothly down to zero velocity
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	# 5. Execute the physics engine slide movement
	move_and_slide()
