extends Node2D
var Team = 1
var Artillery = preload("res://ArtilleryImpact.tscn")
var rng = RandomNumberGenerator.new()
var Type = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1.5).timeout
	if Type == "Artillery":
		var NewObj = Artillery.instantiate()
		NewObj.global_position = global_position + Vector2(rng.randf_range(-48,48),rng.randf_range(-48,48))
		NewObj.Team = Team
		NewObj.Damage = 50
		get_parent().call_deferred("add_child",NewObj)
		await get_tree().create_timer(1).timeout
		var NewObj2 = Artillery.instantiate()
		NewObj2.global_position = global_position + Vector2(rng.randf_range(-48,48),rng.randf_range(-48,48))
		NewObj2.Team = Team
		NewObj2.Damage = 50
		get_parent().call_deferred("add_child",NewObj2)
		await get_tree().create_timer(1).timeout
		queue_free()
	elif Type == "Airstrike":
		await get_tree().create_timer(10).timeout
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
