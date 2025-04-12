extends Node2D

func _ready() -> void:
	ResourceTick()

func _process(delta: float) -> void:
	Globals.MousePos = get_global_mouse_position()


func _on_nav_mesh_timer_timeout() -> void:
	if Globals.ChangedMesh == true:
		Globals.ChangedMesh = false
		$NavigationRegion2D.bake_navigation_polygon()
		$NavigationRegion2D2.bake_navigation_polygon()
	#print("baking")

func ResourceTick():
	await get_tree().create_timer(1).timeout
	for i in range(0,Globals.BunnyPower.size()):
		Globals.BunnyPower[i] += 5
		Globals.Munitions[i] += 1
		Globals.Fuel[i] += 1
	ResourceTick()
