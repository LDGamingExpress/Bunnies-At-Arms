extends Node2D


func _process(delta: float) -> void:
	Globals.MousePos = get_global_mouse_position()


func _on_nav_mesh_timer_timeout() -> void:
	$NavigationRegion2D.bake_navigation_polygon()
	$NavigationRegion2D2.bake_navigation_polygon()
	#print("baking")
