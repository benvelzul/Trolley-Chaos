extends CharacterBody2D

@export var speed: float = 150.0
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var animated_sprite = $AnimatedSprite2D 

func _physics_process(_delta: float) -> void:
	# Safely exit if the player is dead or does not exist
	if not player:
		print("no player")
		return
	
	# 1. Calculate the direction vector toward the player
	var direction: Vector2 = global_position.direction_to(player.global_position)
	
	look_at(player.global_position)
	
	animated_sprite.play('walk')
	
	# 2. Set the velocity vector (Direction * Speed)
	velocity = direction * speed
	
	# 3. Apply physics and handle collisions automatically
	move_and_slide()
