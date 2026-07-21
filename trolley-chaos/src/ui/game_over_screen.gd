# game_over_screen.gd
extends CanvasLayer

# Adjust these variables to change how the floating feels
@export var float_speed: float = 4.0      # How fast it goes up and down
@export var float_amplitude: float = 15.0  # How many pixels it moves up and down

@onready var game_over_label: TextureRect = $Label        # Your "GAME OVER" text
@onready var restart_label: TextureRect = $ContinueText      # Your "Press SPACE" text
@onready var digits_box: HBoxContainer = $HighScoreContainer/DigitsBox
@onready var highscore_word: TextureRect = $HighScoreContainer/HighScoreWord
@onready var secs_word: TextureRect = $HighScoreContainer/SecsWord


var time_passed: float = 0.0
var original_game_over_y: float = 0.0
var original_restart_y: float = 0.0

func _ready() -> void:
	# Freeze the gameplay behind the UI
	get_tree().paused = true
	
	var top_score = get_node("/root/ScoreManager").high_score
	display_high_score(top_score)
	
	# Save the initial screen positions so we don't drift away
	original_game_over_y = game_over_label.position.y
	original_restart_y = restart_label.position.y

func _process(delta: float) -> void:
	# 1. Handle Spacebar Input
	if Input.is_action_just_pressed("ui_accept"):
		restart_game()
		
	# 2. Track real-world time passing
	time_passed += delta
	
	# 3. Calculate the smooth up/down offset using a sine wave
	var float_offset: float = sin(time_passed * float_speed) * float_amplitude
	
	# 4. Apply the offset to your labels
	game_over_label.position.y = original_game_over_y + float_offset
	
	# Offset the restart text slightly out of sync for a looser visual feel
	var text_offset: float = sin((time_passed * float_speed) + 1.0) * (float_amplitude * 0.5)
	restart_label.position.y = original_restart_y + text_offset
	

func display_high_score(score: int) -> void:
	# Clear out any old number images inside the inner box
	for child in digits_box.get_children():
		child.queue_free()
		
	var score_string = str(score)
	for digit in score_string:
		var rect = TextureRect.new()
		rect.texture = load("res://assets/fonts/number0" + digit + ".png")
		
		# (Your existing working code for numbers)
		var target_size = Vector2(20, 20) 
		rect.custom_minimum_size = target_size
		rect.set_deferred("size", target_size)
		rect.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		rect.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		digits_box.add_child(rect)


func restart_game() -> void:
	# 1. Unpause the engine
	get_tree().paused = false
	
	# 2. Tell the engine to swap the level behind the scenes
	get_tree().change_scene_to_file("res://src/world/main_map.tscn") # Use your real path here!
	
	# 3. Cleanly destroy this UI instance so it vanishes from the screen
	queue_free()
