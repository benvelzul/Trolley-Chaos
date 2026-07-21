# score_manager.gd
extends Node

const SAVE_PATH = "user://trolley_chaos_save.cfg"

var current_score: int = 0
var high_score: int = 0

func _ready() -> void:
	load_high_score()

func save_high_score(new_score: int) -> void:
	current_score = new_score
	if new_score > high_score:
		high_score = new_score
		
		# Save cleanly to the player's system storage
		var config = ConfigFile.new()
		config.set_value("SaveData", "high_score", high_score)
		config.save(SAVE_PATH)

func load_high_score() -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	# If the file loads successfully, grab the saved value
	if error == OK:
		high_score = config.get_value("SaveData", "high_score", 0)
	else:
		high_score = 0
