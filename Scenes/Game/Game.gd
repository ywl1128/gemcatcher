extends Node2D

class_name Game

const EXPLODE = preload("res://assets/explode.wav")
const GEM_AREA_2D = preload("res://Scenes/Gem/GemArea2d.tscn")
const margin: float = 70.0

@onready var spawntimer: Timer = $SpawnTimer
@onready var paddle_area_2d: Area2D = $Paddle_Area2D
@onready var score: AudioStreamPlayer2D = $Score
@onready var sound: AudioStreamPlayer = $Sound
@onready var score_label: Label = $ScoreLabel

var _score: int = 0
static var _vp_r: Rect2

static func get_vpr() -> Rect2:
	return _vp_r

func _ready() -> void:
	update_vp()
	get_viewport().size_changed.connect(update_vp)
	spawn_gem()
	spawntimer.start()
	
func update_vp() -> void:
	_vp_r = get_viewport_rect()

func spawn_gem() -> void:
	var new_gem: Gem = GEM_AREA_2D.instantiate()
	var x_pos: float = randf_range(
		_vp_r.position.x + margin,
		_vp_r.end.x - margin
	)
	new_gem.position = Vector2(x_pos, -margin)
	new_gem.gem_off_screen.connect(_on_gem_area_2d_gem_off_screen)
	add_child(new_gem)

func stop_all() -> void:
	sound.stop()
	sound.stream = EXPLODE
	sound.play()
	spawntimer.stop()
	paddle_area_2d.set_process(false)
	for child in get_children():
		if child is Gem:
			child.set_process(false)

func _on_paddle_area_2d_area_entered(area: Area2D) -> void:
	_score += 1
	score_label.text = "%03d" % _score
	if score.playing == false:
		score.position = area.position
		score.play()


func _on_gem_area_2d_gem_off_screen() -> void:
	stop_all()


func _on_timer_timeout() -> void:
	spawn_gem()
