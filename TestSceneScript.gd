extends Node2D


func _process(delta: float) -> void:
	Globals.MousePos = get_global_mouse_position()
