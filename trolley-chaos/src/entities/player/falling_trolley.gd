# falling_trolley.gd
extends Sprite2D

var velocity: Vector2 = Vector2.ZERO
var rotation_speed: float = 0.0

func _ready() -> void:
	# Launch the trolley upwards and backwards randomly when it appears
	velocity = Vector2(randf_range(-150, 150), -350)
	# Make it spin rapidly
	rotation_speed = randf_range(-10, 10)

func _process(delta: float) -> void:
	# Simple physics simulation without requiring a RigidBody2D node
	velocity.y += 980 * delta # Gravity pulling it down
	position += velocity * delta
	rotation += rotation_speed * delta
