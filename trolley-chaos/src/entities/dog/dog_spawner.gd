extends Node2D

# 1. Drag and drop your Enemy.tscn scene file here from the FileSystem
@export var enemy_scene: PackedScene

@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	# Connect the timer's timeout signal to our spawn function
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout() -> void:
	# Safely exit if no enemy scene has been assigned in the Inspector
	if not enemy_scene:
		print("Warning: No enemy scene assigned to the spawner!")
		return
		
	# 2. Instance the enemy scene into memory
	var enemy_instance = enemy_scene.instantiate()
	
	var random_offset = Vector2(randf_range(-200, 200), randf_range(-200, 200))
	enemy_instance.global_position = global_position + random_offset

	spawn_timer.wait_time = randf_range(20, 50)
	
	# 4. Add the enemy to the active game world 
	# (Adding it to the main scene tree prevents movement bugs if the spawner moves)
	get_tree().current_scene.add_child(enemy_instance)
