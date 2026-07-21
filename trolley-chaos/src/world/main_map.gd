# main_level.gd
extends Node2D

@onready var digits_box: HBoxContainer = $CanvasLayer/ScoreContainer/DigitsBox
@onready var secs_word: TextureRect = $CanvasLayer/ScoreContainer/SecsWord

var time_survived: float = 0.0

# Inside your main level script where the survival time is tracked:
func _process(delta: float) -> void:
	time_survived += delta
	update_score_display(int(time_survived))
	
	# Keep the ScoreManager updated on the current run's progress
	get_node("/root/ScoreManager").current_score = int(time_survived)

func update_score_display(score: int) -> void:
	# 1. Clear out the old digit images
	for child in digits_box.get_children():
		child.queue_free()
		
	# 2. Force the "SECS" word to stay small so it isn't massive!
		# 2. Force the "SECS" word to stay small and stop expanding
	if secs_word:
		var text_size = Vector2(100, 80) # Change this to make the word "SECS" smaller or larger!
		secs_word.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		secs_word.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		secs_word.custom_minimum_size = text_size
		secs_word.set_deferred("size", text_size)
		
		# --- FORCE SECS WORD CONTAINER FLAGS ---
		secs_word.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		secs_word.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	# 3. Break the score down into characters
	var score_string = str(score)
	
	for digit in score_string:
		var rect = TextureRect.new()
		rect.texture = load("res://assets/fonts/number0" + digit + ".png")
		
		# --- FORCE NEW SMALLER SIZE HERE ---
		rect.custom_minimum_size = Vector2(60, 60) # Adjust these values to make the numbers exactly the size you want!
		rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE 
		rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED 
		
		# Add it to your layout box row
		digits_box.add_child(rect)
