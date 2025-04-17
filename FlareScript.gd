extends Node2D
var Team = 1
var Artillery = preload("res://ArtilleryImpact.tscn")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1.5).timeout
	var NewObj = Artillery.instantiate()
	NewObj.global_position = global_position + Vector2(rng.randf_range(-48,48),rng.randf_range(-48,48))
	NewObj.Team = Team
	get_parent().add_child(NewObj)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
