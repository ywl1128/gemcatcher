extends Area2D

class_name Gem

signal gem_off_screen

const SPEED: float = 150.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += SPEED * delta
	
	if position.y > Game.get_vpr().end.y:
		print("Gem falls off")
		gem_off_screen.emit()
		die()

func die() -> void:
	set_process(	false)
	queue_free()

func _on_area_entered(_area: Area2D) -> void:
	print("Gem hits the paddle")
	die()
