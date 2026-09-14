extends Control

# --- Floating Animation Variables ---
@export var float_speed: float = 4.0      
@export var float_amplitude: float = 15.0  

# --- Pacing Sprite Variables ---
@export var sprite_speed: float = 150.0   # Speed in pixels per second
var move_direction: float = 1.0           # 1.0 = Right, -1.0 = Left

# --- Node References ---
@onready var trolley_title: TextureRect = $TrolleyTitle
@onready var chaos_title: TextureRect = $ChaosTitle
@onready var play_button: Button = $PlayButton
@onready var quit_button: Button = $QuitButton
@onready var pacing_sprite: AnimatedSprite2D = $AnimatedSprite2D 

# --- Position Tracking Variables ---
var time_passed: float = 0.0
var original_title_trolley_y: float = 0.0
var original_title_chaos_y: float = 0.0
var screen_width: float = 0.0

func _ready() -> void:
	original_title_trolley_y = trolley_title.position.y
	original_title_chaos_y = chaos_title.position.y
	
	# Fetch the current game viewport width for boundary checking
	screen_width = get_viewport_rect().size.x
	
	# Play your sprite's default walking/moving animation
	pacing_sprite.play("default") 
	
	# Connect your button signals if you haven't in the editor editor
	play_button.pressed.connect(_on_play_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _process(delta: float) -> void:
	# 1. Handle Main Menu Floating (Same as your Game Over logic)
	time_passed += delta
	var float_offset: float = sin(time_passed * float_speed) * float_amplitude
	trolley_title.position.y = original_title_trolley_y + float_offset
	chaos_title.position.y = original_title_chaos_y + float_offset
	
	# 2. Handle Pacing Sprite Movement
	pacing_sprite.play('start')
	pacing_sprite.position.x -= sprite_speed * move_direction * delta
	
	# 3. Handle Screen Boundary Check & Flipping
	check_screen_boundaries()

func check_screen_boundaries() -> void:
	# Check Right Edge
	if pacing_sprite.position.x >= screen_width:
		move_direction = 1.0
		pacing_sprite.flip_h = false # Flip sprite to look left
		
	# Check Left Edge
	elif pacing_sprite.position.x <= 0:
		move_direction = -1.0
		pacing_sprite.flip_h = true # Flip sprite to look right

func _on_play_button_pressed() -> void:
	# Changes scene to your gameplay map
	get_tree().change_scene_to_file("res://src/world/main_map.tscn")

func _on_quit_button_pressed() -> void:
	# Safely closes the game application
	get_tree().quit()
