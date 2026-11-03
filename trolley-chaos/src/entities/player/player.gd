extends CharacterBody2D

@export var base_speed = 200.0
@export var boost_speed = 500.0
@export var normal_friction = 1000.0
@export var drift_friction = 150.0 # Low friction for smooth sliding
@export var max_speed = 800.0 

@onready var animated_sprite = $AnimatedSprite2D 
@export var tile_map_layer: TileMapLayer

# Optional reference to camera if you want to control it via code
@export var camera_2d: Camera2D 

var is_drifting = false
var drift_velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var direction_to_mouse: Vector2 = global_position.direction_to(mouse_pos)
	var speed_multiplier := get_tile_speed_multiplier()
	
	# 1. Input Handling for Drift (Right-Click) and Boost (Left-Click or vice versa)
	# Based on your preference: Right-click = Drift, Left-click = Boost/Push
	var drift_input = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	var boost_input = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	
	if drift_input:
		if not is_drifting:
			# Just started drifting, capture current momentum
			is_drifting = true
			drift_velocity = velocity
			
		# During drift: low friction, maintain momentum, allow subtle steering/leaning
		velocity = velocity.move_toward(Vector2.ZERO, drift_friction * delta)
		
		# Optional: Allow mouse to slightly influence the slide direction while drifting
		var steer_force = direction_to_mouse * (base_speed * 0.5) * speed_multiplier
		velocity += steer_force * delta
		
		animated_sprite.play("walk")
	else:
		if is_drifting:
			is_drifting = false # Exit drift mode when button is released
			
		if boost_input:
			# Boost forward
			var target_velocity = direction_to_mouse * boost_speed * speed_multiplier
			velocity = velocity.move_toward(target_velocity, boost_speed * delta * 4)
			animated_sprite.play("walk")
		else:
			# Normal movement / constant rolling with normal friction
			var target_velocity = direction_to_mouse * base_speed * speed_multiplier
			velocity = velocity.move_toward(target_velocity, normal_friction * delta)
			
			if velocity.length() > 10:
				animated_sprite.play("walk")
			else:
				animated_sprite.play("idle")

	# Smoothly rotate trolley toward mouse only when not heavily drifting sideways
	if not drift_input:
		var target_angle: float = direction_to_mouse.angle()
		rotation = lerp_angle(rotation, target_angle, 0.2)

	velocity = velocity.limit_length(max_speed)
	move_and_slide()

func get_tile_speed_multiplier() -> float:
	if not tile_map_layer:
		return 1.0

	var local_pos := tile_map_layer.to_local(global_position)
	var map_pos := tile_map_layer.local_to_map(local_pos)
	
	var tile_data := tile_map_layer.get_cell_tile_data(map_pos)
	if tile_data:
		var mult = tile_data.get_custom_data("speed_multiplier")
		if mult != null:
			return float(mult)
			
	return 1.0
