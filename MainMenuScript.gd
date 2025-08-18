extends Node2D
var MainBus = AudioServer.get_bus_index("Master")
var SFXBus = AudioServer.get_bus_index("SFX")
var MusicBus = AudioServer.get_bus_index("Music")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.set_bus_volume_db(SFXBus,linear_to_db(0.2))
	Globals.Menu = true
	$Camera2D/CanvasLayer/Menu/OptionsMenu/MusicLevel/MusicLevel.value = AudioServer.get_bus_volume_linear(MusicBus) * 100.0
	$Camera2D/CanvasLayer/Menu/OptionsMenu/SFXLevel/SFXSlider.value = AudioServer.get_bus_volume_linear(SFXBus) * 100.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_play_button_pressed() -> void:
	$Camera2D/CanvasLayer/Menu/MainMenu.visible = false
	$Camera2D/CanvasLayer/Menu/MapMenu.visible = true


func _on_options_button_pressed() -> void:
	$Camera2D/CanvasLayer/Menu/MainMenu.visible = false
	$Camera2D/CanvasLayer/Menu/OptionsMenu.visible = true


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	var NewLevel = linear_to_db($Camera2D/CanvasLayer/Menu/OptionsMenu/SFXLevel/SFXSlider.value/100.0)
	AudioServer.set_bus_volume_db(SFXBus, NewLevel)


func _on_music_level_drag_ended(value_changed: bool) -> void:
	var NewLevel = linear_to_db($Camera2D/CanvasLayer/Menu/OptionsMenu/MusicLevel/MusicLevel.value/100.0)
	AudioServer.set_bus_volume_db(MusicBus, NewLevel)


func _on_options_back_pressed() -> void:
	$Camera2D/CanvasLayer/Menu/MainMenu.visible = true
	$Camera2D/CanvasLayer/Menu/OptionsMenu.visible = false


func _on_map_back_pressed() -> void:
	$Camera2D/CanvasLayer/Menu/MainMenu.visible = true
	$Camera2D/CanvasLayer/Menu/MapMenu.visible = false


func _on_tutorial_map_pressed() -> void:
	Globals.Menu = false
	Globals.Units = [0,0]
	get_tree().change_scene_to_file("res://TestScene.tscn")


func _on_river_map_pressed() -> void:
	Globals.Menu = false
	Globals.Units = [0,0]
	get_tree().change_scene_to_file("res://RiverMap.tscn")


func _on_forest_map_pressed() -> void:
	Globals.Menu = false
	Globals.Units = [0,0]
	get_tree().change_scene_to_file("res://SecludedForestMap.tscn")


func _on_bridge_map_pressed() -> void:
	Globals.Menu = false
	Globals.Units = [0,0]
	get_tree().change_scene_to_file("res://ABridgeTooFarMap.tscn")


func _on_konnenburg_map_pressed() -> void:
	Globals.Menu = false
	Globals.Units = [0,0]
	get_tree().change_scene_to_file("res://KonnenburgMap.tscn")
