extends CharacterBody2D

@export var speed: float = 200.0

@onready var vision_area: Area2D = $VisionArea
@onready var raycast: RayCast2D = $LineOfSight
@onready var animated_sprite = $AnimatedSprite2D 

var target_player: Node2D = null

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	
	if target_player and can_see_player():
		var direction: Vector2 = global_position.direction_to(target_player.global_position)
		velocity = direction * speed
		look_at(target_player.global_position)
		animated_sprite.play('walk')
		
	else: 
		animated_sprite.play("idle")
	move_and_slide()


func can_see_player() -> bool:
	# Calculate target position relative to the RayCast's position
	raycast.target_position = raycast.to_local(target_player.global_position)
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.is_in_group("Player"):
			return true
			
	return false

func _on_vision_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target_player = body

func _on_vision_area_body_exited(body: Node2D) -> void:
	if body == target_player:
		target_player = null

# Change your signal connection to watch for an Area2D entering
# Inside your Enemy script
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerHitbox"):
		print("Trolley Chaos Crash!")
		
		# 1. Trigger the Screen Shake
		var camera = get_tree().get_first_node_in_group("GameCamera")
		if camera:
			camera.start_shake(15.0) # Adjust this number for a more violent shake!

		# 2. Find and Hide the original player trolley
		var player_node = area.get_parent()
		if player_node:
			player_node.visible = false
			player_node.set_physics_process(false) # Freeze player controls
			
			# 3. Spawn your falling trolley artwork at the exact crash site
			var falling_scene = load("res://src/entities/player/falling_trolley.tscn")
			var falling_instance = falling_scene.instantiate()
			falling_instance.global_position = player_node.global_position
			get_tree().root.add_child(falling_instance)
			
		# 4. Let the trolley tumble through the air for a brief moment
		await get_tree().create_timer(0.6).timeout 
		
		# CHANGE THIS LINE: Use the score already stored in the manager!
		var final_score = get_node("/root/ScoreManager").current_score
		get_node("/root/ScoreManager").save_high_score(final_score)
		
		# 5. Open your spacebar-ready Game Over menu!
		show_game_over()

func show_game_over() -> void:
	# 1. Load the Game Over UI scene file from your file system
	# IMPORTANT: Double check that this path matches your file name exactly!
	var game_over_scene = load("res://src/ui/game_over_screen.tscn")
	
	# 2. Create a live copy (instance) of that scene
	var game_over_instance = game_over_scene.instantiate()
	
	# 3. Add it to the root of your running game window so it draws on top of everything
	get_tree().root.add_child(game_over_instance)
