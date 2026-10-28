extends Control

@export var float_speed: float = 4.0      
@export var float_amplitude: float = 15.0  

@export var sprite_speed: float = 150.0  
var move_direction: float = 1.0           

@onready var trolley_title: TextureRect = $TrolleyTitle
@onready var chaos_title: TextureRect = $ChaosTitle
@onready var play_button: Button = $PlayButton
@onready var quit_button: Button = $QuitButton
@onready var pacing_sprite: AnimatedSprite2D = $AnimatedSprite2D 

var time_passed: float = 0.0
var original_title_trolley_y: float = 0.0
var original_title_chaos_y: float = 0.0
var screen_width: float = 0.0

func _ready() -> void:
	original_title_trolley_y = trolley_title.position.y
	original_title_chaos_y = chaos_title.position.y
	
	screen_width = get_viewport_rect().size.x

	pacing_sprite.play("start") 
	
	play_button.pressed.connect(_on_play_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _process(delta: float) -> void:
	time_passed += delta
	var float_offset: float = sin(time_passed * float_speed) * float_amplitude
	trolley_title.position.y = original_title_trolley_y + float_offset
	chaos_title.position.y = original_title_chaos_y + float_offset
	
	pacing_sprite.position.x -= sprite_speed * move_direction * delta
	
	check_screen_boundaries()

func check_screen_boundaries() -> void:
	if pacing_sprite.position.x >= screen_width:
		move_direction = 1.0
		pacing_sprite.flip_h = false 
		
	elif pacing_sprite.position.x <= 0:
		move_direction = -1.0
		pacing_sprite.flip_h = true 

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/world/main_map.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
