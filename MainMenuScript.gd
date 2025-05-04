extends Node2D
var MainBus = AudioServer.get_bus_index("Master")
var SFXBus = AudioServer.get_bus_index("SFX")
var MusicBus = AudioServer.get_bus_index("Music")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.set_bus_volume_db(SFXBus,linear_to_db(0.2))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
