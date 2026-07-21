# game_camera.gd
extends Camera2D

var shake_amount: float = 0.0
var shake_decay: float = 5.0 # How fast the shaking stops
var original_offset: Vector2

func _ready() -> void:
	original_offset = offset
	# Give the camera a unique name so the enemy can easily find it from anywhere
	add_to_group("GameCamera")

func _process(delta: float) -> void:
	if shake_amount > 0:
		# Pick a random offset based on the remaining shake strength
		offset.x = original_offset.x + randf_range(-shake_amount, shake_amount)
		offset.y = original_offset.y + randf_range(-shake_amount, shake_amount)
		
		# Gradually slow down the shake over time
		shake_amount = move_toward(shake_amount, 0.0, shake_decay * delta * 10)
	else:
		offset = original_offset

func start_shake(intensity: float) -> void:
	shake_amount = intensity
